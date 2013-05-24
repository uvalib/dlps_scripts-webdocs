#!/usr/local/bin/python 

from __future__ import generators
import os,sys,time
from os import path,listdir
from os.path import join,getsize,isdir,isfile,abspath

print 'checking python version', sys.version
if sys.version < '2.3' : 
	print "This program uses functions and features from python 2.3 or greater"
	sys.exit(1)


# Actual physical capacity of CD-R 
#  2048 bytes blocks * number of blocks:
_CD80min = 2048 * 360000
_CD74min = 2048 * 330000
_DVDmax  = 2297888 * 2048  # 4472  * 1024 * 1024 # or should it be:  2297888 * 2048 ? ( 4488 * 1024*1024 )
# default actual data max for diskful iterator:
_CDSIZE =         688 * 1024 * 1024			# use somewhat less that max 
_DVDSIZE  =   2183040 * 2048 

# these were added to test switching from Data Pub to Network Pub J
_DVD = 'DVDR'  #  'DVDR' for  Network Publisher, 'DVD' for Data Publisher
_ORD_EXT = '.nwp'  # '.ord' for Data Pub,  '.nwp' for net pub 


# You can test writing the order files without burning disks on any host 
# Some of the path names should be the only system dependent things in the program:
if os.name == 'posix' :			# actually, Mac OSX -- for testing and development only  
	_ORDER_ROOT = os.path.abspath( os.curdir )
	_LOGS = _MERGE = _EDITLIST  = _JOB_DEST = _ORDER_ROOT
	_LABEL_FILE = "default.btw"	
elif os.name == 'nt' :			
	_ORDER_ROOT = 'C:\\Rimage' 
	_MERGE = join( _ORDER_ROOT, "Merge" )
	_EDITLIST = join( _ORDER_ROOT, "Editlist" )
	_JOB_DEST = join( _ORDER_ROOT, "Publisher Orders" )
	_LABEL_FILE = join( _ORDER_ROOT, "Labels", "DEFAULT.btw" )
	_LOGS = join( _ORDER_ROOT, "Logs" )



from glob import glob
class JobID:
	"""Class to generate unique job id numbers: YYMMDDNNN where
		YYMMDD is six digit date string and NNN is a sequence number.
		nextid = JobID().next;    id = nextid() """
	def __init__(self):	
		self.datestr = ("%4d%02d%02d_"  % time.localtime()[:3])[2:]
		self.scan()
	def __iter__(self):
		return self
	def next(self):
		self.job = '%s%03d' % ( self.datestr, self.n ) 
		self.n += 1
		return self.job
	def scan(self):
		"""scan() checks to see if there are any existing files with todays ID datestr 
		   before initializing the counter."""
		files = glob( join( _JOB_DEST, self.datestr + "[0-9][0-9][0-9]" + _ORD_EXT ) ) + \
						glob( join( _JOB_DEST, self.datestr + "[0-9][0-9][0-9].[a-z]*[0-9]" ))
		if files: 
			try:
				files.sort()
				self.n = int( os.path.splitext(files[-1])[0][-3:] ) + 1
			except:
				self.n = 1
		else: self.n = 1



class Order:
	_MERGE_DELIM = ', '	# comma delimited label/merge files -- can possibly be tab or other 
	copies = 2
	fixrate = 'NOAPPEND'
	media = _DVD
	label = _LABEL_FILE
	filetype = 'EDITLIST'
	_jobid = JobID().next
	_project = ''
	
	def __init__(self, **dargs ):
		self.order_id = self.volume = self._jobid()
		self.file =  os.path.join( _EDITLIST, self.order_id + ".lis" )
		self.merge = os.path.join( _MERGE, self.order_id + ".txt" )
		for k,v in dargs.items():
			setattr(self, k, v )
		self._files = []
		print "OPEN: ", self.volume,  ( "+" * 20 )
	def _keys(self):
		d = self.__class__.__dict__.copy()
		d.update( self.__dict__ )
		keys = d.keys()
		keys.sort()
		return [ k for k in keys if not k.startswith('_') ] 
	def __str__(self):
		return '\n'.join( [ "%s = %s" % (k, getattr(self,k)) for k in self._keys() ])+ '\n' 
	def _append( self, dst, src ):
		if dst[0] <> os.path.sep : dst = os.path.sep + dst
		self._files.append( ( dst, src ) )
		print "    <--- ",src
	def _editlist( self ):
		return '\n'.join( [ ( '"%s" "%s"'  % line  )  for  line  in self._files ]  ) + '\n' 
	def _filelist( self ):
		return [ dst for dst,src in self._files ]
	def _toplevels(self):
		tl = []
		for dst,src in self._files:
			top = os.path.sep.join( dst.split( os.path.sep )[:2] )
			if top not in tl: tl.append( top )
		return tl
	def _merge(self):
		return self._MERGE_DELIM.join( self._mergelist )  + '\n' 
	def _log( self, output=sys.stdout ):
		if self._project : output.write( 'Project = ' + self._project + '\n' )
		output.write( 'Date = ' + self._date() + '\n' )
		output.write( 'Expires = ' + self._expires() + '\n' )
		output.write( 'Format = ' + self._diskformat() + '\n' )
		output.write( 'NumberOfFiles = ' + str(len(self._files)) + '\n' )
		output.write( self.__str__() )
		output.write( '\n' )
		for file in self._filelist():
			output.write( file + '\n' )
	def _diskformat(self):
		# this is more or less a placeholder at the moment...
		if self.media == _DVD : return 'UDF102'
		else: return 'ISO 9660'
	def _close(self):
		print 'CLOSE: ', self.volume, ( "-" * 20 )
		imtype = self._diskformat()
		if self.media == 'DVDR' : 
			self.imtype = imtype
		tl = self._toplevels()
		self.logmessage =  '"' + ';'.join( tl )[:252] + '"'
		self._mergelist = [ self.volume, 'Date: ' + self._date(), 'Expires: ' + self._expires(),  
				self._files[0][0], self._files[-1][0], self._diskformat(),  ( "%d files" % len(self._files)) ]
		open( self.file, 'w' ).write( self._editlist() )
		open( self.merge, 'w' ).write( self._merge() )
		out = open( os.path.join( _JOB_DEST, self.order_id + _ORD_EXT ), 'w' )
		out.write( self.__str__() )
		out.close()
		self._log( output=open( os.path.join( _LOGS, self.order_id + '.log' ), 'w' ))
	def _date(self):
		return time.strftime( '%a %b %d %Y' )	
	def _expires(self):
		expires = time.localtime()
		expires = ( expires[0] + 5, ) + expires[1:] 
		return time.strftime( '%a %b %d %Y', expires )


hidden = None
if os.name == 'nt' :
	from win32api import GetFileAttributes
	from win32con import FILE_ATTRIBUTE_HIDDEN
	def hidden( path ):
		try:
			return GetFileAttributes( path ) & FILE_ATTRIBUTE_HIDDEN
		except:
			return False


## skip by name or by attributes : by attributes requires path
def skipname( name ):
	"file or directory names to skip  -- don't do '.dot' or '~tilde' files and other misc skip files"
	if name.startswith( '.' ) or name.startswith( '~' ) or \
			name.startswith( '2eDS_' ) or name.startswith( '2EDS_' ):
		return True
	elif name[-1] == '~' : return True
	elif name == 'tmp' : return True
	else: return False

def skipfile( path ):
	if hidden: return hidden(path)
	else: return False

def walk( root ):	#  walks file hierarchy with filtering of skipped files
	for d,dirlist,filelist in os.walk(root):
		for name in dirlist[:]:
			if skipname(name) or skipfile(join(d,name)) : dirlist.remove(name)
		for name in filelist[:]:
			if skipname(name) or skipfile(join(d,name)): filelist.remove(name) 
		yield d,dirlist,filelist

def rsize( root ):
	"rsize( root ) --> total size of all files in root directory and subdirectories"
	if ( not isdir( root )) : 
		return getsize( root ) 	## Not a dir?-- return size of file.
	tot = 0						## otherwise, walk the dir tree and total the sizes
	for base,dirs,files in walk( root ):
		tot += getsize( base )
		tot += sum( [getsize(join(base,name)) for name in files ] )
	return tot

def rfiles( root ):
	if isfile(root) : return [root]
	result = []
	for r,d,f in walk( root ):
		for name in f: 
			result.append(join( r, name ))
	return result

def partname( d, n ):		# returns 'part_a','part_b', 'part_c', ... for d='part', n = 1,2,3... 
	return '%s_%s' % ( d, chr(ord('a')-1+n) )


def rsplit( root, media=_DVD ):

	if media == _DVD :  maxsize = _DVDSIZE 
	elif media == 'CDR' : maxsize = _CDSIZE 
	elif media == 'TEST' : maxsize = 90 * 1024 * 1024   # small test size
	
	print "MEDIA: ", media, maxsize

	root = abspath( root )
	rlen = len( root )
	total = 0

	Order._project = root
	job_order = Order( media=media )
		
	for filename in listdir( root ):
		filepath = join( root, filename )
		if skipname( filename ) or skipfile( filepath ) : 
			continue
		if isdir(filepath) : print filename + os.path.sep + "..." 
		else: print filename
		parts = 0	
		size = rsize( filepath )
		if total + size > maxsize :		# too big ? 
			if isfile( filepath ):			# can't split files further: FINISH THIS SET

				if total == 0 : 			# if empty set, then problem:
					if getsize( filepath ) > maxsize : 
						raise RuntimeError, 'File too big: ' + filepath
					else: raise RuntimeError, 'unexpected error'

				job_order._close()
				job_order = Order( media=media )
				job_order._append( filename, abspath(filepath))
				total = size

			elif isdir( filepath ):		# try to split directories
				parts = 1
				for filename2 in listdir( filepath ):
					filepath2 = join( filepath, filename2 )
					if skipname( filename2 ) or skipfile( filepath2 ) :
						continue
					part_size = rsize( filepath2 )
					if total + part_size > maxsize :	# FINISHed partial
						
						# if empty set ...
						if total == 0 :
							if part_size > maxsize:
								raise RuntimeError, 'File or directory too big: '+filepath2 
							else: raise RuntimeError, 'unexpected error'

						job_order._close()
						job_order = Order( media=media )
						total = 0;  parts += 1
						print "BEGIN Part #", parts, "(", partname(filepath,parts),") of", filename			

					total += part_size 
					dstroot = join( partname( filepath, parts ), filename2 ) 
					plen = len(filepath2) + 1
					if isdir(  filepath2 ):
						for fname in  rfiles( filepath2 ):
							job_order._append( join(dstroot[rlen:],fname[plen:]), 
									join(filepath2, fname)) 
					else:	 job_order._append( dstroot[rlen:], filepath2  )
			else: raise RuntimeError, 'Not a regular file or a directory: ' + filepath				
		else: # if it fits, then add it to the current set
			total += size
			if isfile( filepath ):		# either as a file
					job_order._append(filename, abspath(filepath))
			elif isdir( filepath ):	# or as recursive listing of dir contents
				for f in rfiles( filepath ): 
					job_order._append( f[rlen:], f )
			else: raise RuntimeError, 'Not a regular file or directory: ' + filepath

	if total :		# once more for the remainder 	
		print 'Last order.' 	
		job_order._close()



#
#  a simple Tk GUI front end to prompt for the root directory
#  and ask for any other options
#

from Tkinter import Tk
from tkSimpleDialog import askstring
from SimpleDialog import SimpleDialog
from tkFileDialog import askdirectory

def getparams():
	rootdir = os.path.abspath( os.path.curdir )
	
	tkroot = Tk()
	
	rootdir = askdirectory( initialdir=rootdir, title='Choose Root Directory' )
#   NO  '-message' on win32 tk   # 	message='Choose root directory to process' )
	
	bb = [_DVD, 'CDR', 'TEST', 'Cancel' ]
	d = SimpleDialog( tkroot,  
				text="Please choose media type for   " + rootdir,
				buttons=bb,
				default=bb.index(_DVD), 
				cancel=bb.index('Cancel'),
				title='Media' )		
	
	d.frame.winfo_toplevel().tkraise()
	media = bb[d.go()]
	tkroot.destroy()
	return rootdir, media
	
				
if __name__ == '__main__' :
	if sys.argv[2:]:
		rsplit( sys.argv[1], media=sys.argv[2] )
	elif sys.argv[1:]:
		rsplit( sys.argv[1] )
	else:
		root, media = getparams( )
		if media <> 'Cancel' : 
			rsplit( root, media=media )
		time.sleep( 30 )
		raw_input( 'Done. ' )
		time.sleep( 30 )



