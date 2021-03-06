FasdUAS 1.101.10   ��   ��    k             l     �� ��    J D License and Copyright: The contents of this file are subject to the       	  l     �� 
��   
 O I Educational Community License (the "License"); you may not use this file    	     l     �� ��    R L except in compliance with the License. You may obtain a copy of the License         l     �� ��    5 / at http://www.opensource.org/licenses/ecl1.txt         l     ������  ��        l     �� ��    Q K Software distributed under the License is distributed on an "AS IS" basis,         l     �� ��    S M WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for         l     �� ��    T N the specific language governing rights and limitations under the License.</p>         l     ������  ��        l     ��  ��     M G The entire file consists of original code.  Copyright (c) 2002-2005 by      ! " ! l     �� #��   # = 7 The Rector and Visitors of the University of Virginia.    "  $ % $ l     �� &��   &   All rights reserved.    %  ' ( ' l     ������  ��   (  ) * ) l     �� +��   + !  Script: iris2tabbed13step2    *  , - , l     �� .��   . i c Description: This script extracts IRIS image and source data for mapping to GDMS into a flat file.    -  / 0 / l     �� 1��   1 f `		Data is written out to a tab delimited file for use by a Perl Script. This script must be run     0  2 3 2 l     �� 4��   4 V P		after the iris2tabbed13step1 script. The IRIS export date fields are modified.    3  5 6 5 l     ������  ��   6  7 8 7 l     �� 9��   9 a [ NOTE: Make sure to set the irisPassword field to a valid value that allows for logging in.    8  : ; : l     ������  ��   ;  < = < l     �� >��   > / ) Author: Jack Kelly  <jlk4p@virginia.edu>    =  ? @ ? l     ������  ��   @  A B A l     �� C��   C ] W 2006/05/16 - (jlk4p) Make changes to resolve the timeout issue by increasing time out     B  D E D l     �� F��   F @ :             seconds and removing display dialog commands.    E  G H G l     �� I��   I [ U 2006/06/01 - (jlk4p) Modified to include new fields for special collections content.    H  J K J l     �� L��   L w q 2006/06/05 - (jlk4p) Finishing up the addition of new fields: Vendor set no., identifier type, identifier number    K  M N M l     �� O��   O u o			and vendor code. Plus trimming excessive whitespace from the end of data fields to prevent multiline record.    N  P Q P l     �� R��   R � } 2006/06/13 - (jlk4p) Added process to update a MySQL db so that the status of this script can be determined from a web page.    Q  S T S l     �� U��   U � } 2006/06/26 - (jlk4p) Add a check to see if the dropbox volume is already mounted and if not then prompt the user to connect.    T  V W V l     �� X��   X p j 2006/08/01 - (jlk4p) Updated the outputDirectory to reflect the new directory structure for sharing data.    W  Y Z Y l     �� [��   [ S M 2007/01/18 - (jlk4p) Remove ul-dlpsscripts from the email distribution list.    Z  \ ] \ l     �� ^��   ^ s m 2007/01/26 - (jlk4p) Updated to move email distribution list to an external file that is read by the script.    ]  _ ` _ l     �� a��   a c ] 2008/01/15 - (jlk4p) Updated sendEmailMessage routine to use Unix command-line mail feature.    `  b c b l     ������  ��   c  d e d l     f�� f r      g h g m      i i  master    h o      ���� 0 irispassword irisPassword��   e  j k j l    l�� l r     m n m b    	 o p o b     q r q m     s s  FMP5://    r o    ���� 0 irispassword irisPassword p m     t t  @udon.lib.virginia.edu/    n o      ���� (0 irisremotelocation irisRemoteLocation��   k  u v u l     �� w��   w 8 2set irisDirectory to "Main:Users:jlk4p:data:IRIS:"    v  x y x l    z�� z r     { | { m     } } 7 1Main:Volumes:DROPBOX:inbox:finearts:iris_exports:    | o      ���� "0 outputdirectory outputDirectory��   y  ~  ~ l     �� ���   � � zset imageProjectStatusURL to "http://localhost/~jlk4p/dlps/applescript_status/updateImageProjectExportStatus.php?" as text      � � � l    ��� � r     � � � c     � � � m     � � i chttp://alioth.lib.virginia.edu/dlps/uva-only/applescript_status/updateImageProjectExportStatus.php?    � m    ��
�� 
ctxt � o      ���� .0 imageprojectstatusurl imageProjectStatusURL��   �  � � � l     ������  ��   �  � � � l    ��� � r     � � � c     � � � m     � �  jlk4p@virginia.edu    � m    ��
�� 
ctxt � o      ���� $0 fromemailaddress fromEmailAddress��   �  � � � l   & ��� � r    & � � � c    $ � � � n   " � � � I    "�� ����� 40 getemaildistributionlist getEmailDistributionList �  ��� � m     � �  email_distribution.config   ��  ��   �  f     � m   " #��
�� 
list � o      ���� (0 toemailaddresslist toEmailAddressList��   �  � � � l     ������  ��   �  � � � l  ' . ��� � r   ' . � � � m   ' * � �  SURROGAT.fp5    � o      ���� 0 irissurrogat irisSurrogat��   �  � � � l  / 6 ��� � r   / 6 � � � m   / 2 � �  WSLINKS.fp5    � o      ���� 0 iriswslinks irisWSLinks��   �  � � � l  7 > ��� � r   7 > � � � m   7 : � �  
SOURCE.fp5    � o      ���� 0 
irissource 
irisSource��   �  � � � l  ? F ��� � r   ? F � � � m   ? B � �  DIGITAL.fp5    � o      ���� 0 irisdigital irisDigital��   �  � � � l  G N ��� � r   G N � � � m   G J � �  SUBJECT.fp5    � o      ���� 0 irissubject irisSubject��   �  � � � l  O V ��� � r   O V � � � m   O R � �  SUBTYPE.fp5    � o      ���� 0 irissubtype irisSubtype��   �  � � � l  W ^ ��� � r   W ^ � � � m   W Z � �  Iris2tabbed.out    � o      ���� 40 outputstatisticsfilename outputStatisticsFilename��   �  � � � l  _ f ��� � r   _ f � � � m   _ b � �  IrisWorkNos.txt    � o      ���� "0 inputworknofile inputWorkNoFile��   �  � � � l  g n ��� � r   g n � � � m   g j � �  IrisWorksExport.err    � o      ���� 0 workserrorlog worksErrorLog��   �  � � � l  o v ��� � r   o v � � � m   o r � �  IrisImagesExport.err    � o      ���� 0 errorlog errorLog��   �  � � � l  w � � � � r   w � � � � c   w � � � � l  w ~ ��� � I  w ~�� ���
�� .sysontocTEXT       shor � m   w z���� 	��  ��   � m   ~ ��
�� 
ctxt � o      ����  0 fieldseparator fieldSeparator �   tab character    �  � � � l  � � � � � r   � � � � � c   � � � � � l  � � ��� � I  � ��� ���
�� .sysontocTEXT       shor � m   � ����� ��  ��   � m   � ���
�� 
ctxt � o      ����  0 valueseparator valueSeparator � %  ascii unit separator character    �  � � � l  � � ��� � r   � � � � � c   � � � � � l  � � ��� � I  � ��� ���
�� .sysontocTEXT       shor � m   � ����� 
��  ��   � m   � ���
�� 
ctxt � o      ���� 0 newline newLine��   �  � � � l  � � ��� � r   � � � � � m   � �����   � o      ���� 0 
errorcount 
errorCount��   �  �  � l  � ��� r   � � m   � �����   o      ���� (0 exportedimagecount exportedImageCount��     l  � ��� r   � � m   � �����   o      ���� &0 projectimagecount projectImageCount��   	
	 l  � ��� r   � � m   � �       o      ���� 0 projectname projectName��  
  l     ������  ��    l     ����   K E getDateTimeString returns a string of the format YYYY-MM-DD HH:MM:SS     i      I      ������ &0 getdatetimestring getDateTimeString �� o      ���� 0 
dateobject 
dateObject��  ��   k    �  q       ���� 0 d   ���� 0 daystr dayStr �� �� 0 m    ��!�� 0 monstr monStr! �"� 0 y  " �~#�~ 0 secs  # �}$�} 0 hrstr hrStr$ �|%�| 0 min  % �{&�{ 0 minstr minStr& �z'�z 0 secstr secStr' �y�x�y  0 datetimestring dateTimeString�x   ()( r     *+* n     ,-, 1    �w
�w 
day - o     �v�v 0 
dateobject 
dateObject+ o      �u�u 0 d  ) ./. Z    01�t20 l   	3�s3 A    	454 o    �r�r 0 d  5 m    �q�q 
�s  1 r    676 c    898 b    :;: m    <<  0   ; o    �p�p 0 d  9 m    �o
�o 
ctxt7 o      �n�n 0 daystr dayStr�t  2 r    =>= c    ?@? o    �m�m 0 d  @ m    �l
�l 
ctxt> o      �k�k 0 daystr dayStr/ ABA r    !CDC n    EFE m    �j
�j 
mnthF o    �i�i 0 
dateobject 
dateObjectD o      �h�h 0 m  B GHG Z   " �IJK�gI l  " %L�fL =   " %MNM o   " #�e�e 0 m  N m   # $�d
�d 
jan �f  J r   ( +OPO m   ( )QQ  01   P o      �c�c 0 monstr monStrK RSR l  . 1T�bT =   . 1UVU o   . /�a�a 0 m  V m   / 0�`
�` 
feb �b  S WXW r   4 7YZY m   4 5[[  02   Z o      �_�_ 0 monstr monStrX \]\ l  : =^�^^ =   : =_`_ o   : ;�]�] 0 m  ` m   ; <�\
�\ 
mar �^  ] aba r   @ Ccdc m   @ Aee  03   d o      �[�[ 0 monstr monStrb fgf l  F Ih�Zh =   F Iiji o   F G�Y�Y 0 m  j m   G H�X
�X 
apr �Z  g klk r   L Omnm m   L Moo  04   n o      �W�W 0 monstr monStrl pqp l  R Ur�Vr =   R Usts o   R S�U�U 0 m  t m   S T�T
�T 
may �V  q uvu r   X [wxw m   X Yyy  05   x o      �S�S 0 monstr monStrv z{z l  ^ a|�R| =   ^ a}~} o   ^ _�Q�Q 0 m  ~ m   _ `�P
�P 
jun �R  { � r   d i��� m   d g��  06   � o      �O�O 0 monstr monStr� ��� l  l q��N� =   l q��� o   l m�M�M 0 m  � m   m p�L
�L 
jul �N  � ��� r   t y��� m   t w��  07   � o      �K�K 0 monstr monStr� ��� l  | ���J� =   | ���� o   | }�I�I 0 m  � m   } ��H
�H 
aug �J  � ��� r   � ���� m   � ���  08   � o      �G�G 0 monstr monStr� ��� l  � ���F� =   � ���� o   � ��E�E 0 m  � m   � ��D
�D 
sep �F  � ��� r   � ���� m   � ���  09   � o      �C�C 0 monstr monStr� ��� l  � ���B� =   � ���� o   � ��A�A 0 m  � m   � ��@
�@ 
oct �B  � ��� r   � ���� m   � ���  10   � o      �?�? 0 monstr monStr� ��� l  � ���>� =   � ���� o   � ��=�= 0 m  � m   � ��<
�< 
nov �>  � ��� r   � ���� m   � ���  11   � o      �;�; 0 monstr monStr� ��� l  � ���:� =   � ���� o   � ��9�9 0 m  � m   � ��8
�8 
dec �:  � ��7� r   � ���� m   � ���  12   � o      �6�6 0 monstr monStr�7  �g  H ��� r   � ���� n   � ���� 1   � ��5
�5 
year� o   � ��4�4 0 
dateobject 
dateObject� o      �3�3 0 y  � ��� r   � ���� n   � ���� 1   � ��2
�2 
time� o   � ��1�1 0 
dateobject 
dateObject� o      �0�0 0 secs  � ��� Z   ����/�� l  � ���.� @   � ���� o   � ��-�- 0 secs  � m   � ��,�,�.  � k   ��� ��� r   � ���� _   � ���� o   � ��+�+ 0 secs  � m   � ��*�*� o      �)�) 0 h  � ��� r   � ���� `   � ���� o   � ��(�( 0 secs  � m   � ��'�'� o      �&�& 0 secs  � ��%� Z   ����$�� l  � ���#� A   � ���� o   � ��"�" 0 h  � m   � ��!�! 
�#  � r   ���� c   ���� b   ���� m   � ���  0   � o   � � �  0 h  � m  �
� 
ctxt� o      �� 0 hrstr hrStr�$  � r  ��� c  ��� o  	�� 0 h  � m  	
�
� 
ctxt� o      �� 0 hrstr hrStr�%  �/  � r  ��� m  ��  00   � o      �� 0 hrstr hrStr� ��� Z  M����� l ��� @  ��� o  �� 0 secs  � m  �� <�  � k  E�� ��� r  %   _  # o  �� 0 secs   m  "�� < o      �� 0 min  �  r  &- `  &+	 o  &'�� 0 secs  	 m  '*�� < o      �� 0 secs   
�
 Z  .E� l .1� A  .1 o  ./�� 0 min   m  /0�� 
�   r  4= c  4; b  49 m  47  0    o  78�
�
 0 min   m  9:�	
�	 
ctxt o      �� 0 minstr minStr�   r  @E c  @C o  @A�� 0 min   m  AB�
� 
ctxt o      �� 0 minstr minStr�  �  � r  HM m  HK  00    o      �� 0 minstr minStr�   Z  Ne!"�#! l NQ$�$ A  NQ%&% o  NO�� 0 secs  & m  OP� �  
�  " r  T]'(' c  T[)*) b  TY+,+ m  TW--  0   , o  WX���� 0 secs  * m  YZ��
�� 
ctxt( o      ���� 0 secstr secStr�  # r  `e./. c  `c010 o  `a���� 0 secs  1 m  ab��
�� 
ctxt/ o      ���� 0 secstr secStr  2��2 r  f�343 c  f�565 b  f�787 b  f�9:9 b  f;<; b  f}=>= b  fy?@? b  fwABA b  fsCDC b  fqEFE b  fmGHG b  fkIJI o  fg���� 0 y  J m  gjKK  -   H o  kl���� 0 monstr monStrF m  mpLL  -   D o  qr���� 0 daystr dayStrB m  svMM      @ o  wx���� 0 hrstr hrStr> m  y|NN  :   < o  }~���� 0 minstr minStr: m  �OO  :   8 o  ������ 0 secstr secStr6 m  ����
�� 
ctxt4 o      ����  0 datetimestring dateTimeString��   PQP l     ������  ��  Q RSR l     ��T��  T getDigitalFile checks for the digital file name and format for the specified IRIS image. A list is returned that contains the filename in the first element, the file format in the second element and image preview URL as the third element. Otherwise empty strings are returned.   S UVU i    WXW I      ��Y����  0 getdigitalfile getDigitalFileY Z��Z o      ���� 0 imagenumber imageNumber��  ��  X k     z[[ \]\ p      ^^ ������ 0 irisdigital irisDigital��  ] _`_ q      aa ��b�� "0 digitalfilename digitalFileNameb ������ 0 digitalformat digitalFormat��  ` cdc O     oefe O    nghg k    mii jkj r    lml o    ���� 0 imagenumber imageNumberm n      non 4    ��p
�� 
ccelp m    qq  Surrogate No.   o 4    ��r
�� 
cRQTr m    ���� k sts I   ��u��
�� .FMPRFINDnull���    obj u 4    ��v
�� 
cwinv m    ���� ��  t w��w Z    mxy��zx l   *{��{ I   *��|��
�� .coredoexbool        obj | l   &}��} n    &~~ 1   $ &��
�� 
vlue n    $��� 4   ! $���
�� 
ccel� m   " #��  Digital Filename   � 1    !��
�� 
pCRW��  ��  ��  y k   - S�� ��� r   - 9��� c   - 7��� n   - 5��� 1   3 5��
�� 
vlue� n   - 3��� 4   0 3���
�� 
ccel� m   1 2��  Digital Filename   � 1   - 0��
�� 
pCRW� m   5 6��
�� 
ctxt� o      ���� "0 digitalfilename digitalFileName� ��� r   : F��� c   : D��� n   : B��� 1   @ B��
�� 
vlue� n   : @��� 4   = @���
�� 
ccel� m   > ?��  Digital Format   � 1   : =��
�� 
pCRW� m   B C��
�� 
ctxt� o      ���� 0 digitalformat digitalFormat� ���� r   G S��� c   G Q��� n   G O��� 1   M O��
�� 
vlue� n   G M��� 4   J M���
�� 
ccel� m   K L�� 	 URL   � 1   G J��
�� 
pCRW� m   O P��
�� 
ctxt� o      ���� 0 
digitalurl 
digitalURL��  ��  z k   V m�� ��� r   V ]��� c   V [��� m   V Y��      � m   Y Z��
�� 
ctxt� o      ���� "0 digitalfilename digitalFileName� ��� r   ^ e��� c   ^ c��� m   ^ a��      � m   a b��
�� 
ctxt� o      ���� 0 digitalformat digitalFormat� ���� r   f m��� c   f k��� m   f i��      � m   i j��
�� 
ctxt� o      ���� 0 
digitalurl 
digitalURL��  ��  h 4    ���
�� 
cDB � o    ���� 0 irisdigital irisDigitalf m     ���null     ߀�� AFileMaker Pro.appe. A list is returned that contains the filenaFMP5   alis    �  Main                       ��#H+   AFileMaker Pro.app                                               Aں� v & � �����  	                FileMaker Pro 6 Folder    � #c      �L3     A     :Main:Applications:FileMaker Pro 6 Folder:FileMaker Pro.app  $  F i l e M a k e r   P r o . a p p  
  M a i n  5Applications/FileMaker Pro 6 Folder/FileMaker Pro.app   / ��  d ���� L   p z�� c   p y��� J   p u�� ��� o   p q���� "0 digitalfilename digitalFileName� ��� o   q r���� 0 digitalformat digitalFormat� ���� o   r s���� 0 
digitalurl 
digitalURL��  � m   u x��
�� 
list��  V ��� l     ������  ��  � ��� l     �����  � | v Retrieves the email distribution list from a text file stored in the same location as the AppleScript being executed.   � ��� i    ��� I      ������� 40 getemaildistributionlist getEmailDistributionList� ���� o      ����  0 configfilename configFileName��  ��  � k     `�� ��� q      �� ����� 0 pathtoscript pathToScript� ����� 0 pathlist pathList� ����� 0 	pathcount 	pathCount� ����� "0 emailconfigfile emailConfigFile� ����� 0 i  � ����� (0 emailaddressstring emailAddressString� ������ 0 	emaillist 	emailList��  � ��� r     	��� I    ����
�� .earsffdralis        afdr�  f     � �����
�� 
rtyp� m    ��
�� 
ctxt��  � o      ���� 0 pathtoscript pathToScript� ��� r   
 ��� c   
 ��� n  
 ��� I    ������� 0 splitstring  � ��� o    ���� 0 pathtoscript pathToScript� ���� m    ��  :   ��  ��  �  f   
 � m    ��
�� 
list� o      ���� 0 pathlist pathList� ��� r    ��� I   �����
�� .corecnte****       ****� o    ���� 0 pathlist pathList��  � o      ���� 0 	pathcount 	pathCount� ��� r    #��� c    !��� m    ��      � m     ��
�� 
ctxt� o      ���� "0 emailconfigfile emailConfigFile� ��� Y   $ A ����  r   0 < c   0 : b   0 8 b   0 6	
	 o   0 1���� "0 emailconfigfile emailConfigFile
 l  1 5�� n   1 5 4   2 5��
�� 
cobj o   3 4���� 0 i   o   1 2���� 0 pathlist pathList��   m   6 7  :    m   8 9��
�� 
ctxt o      ���� "0 emailconfigfile emailConfigFile�� 0 i   m   ' (����  l  ( +�� \   ( + o   ( )���� 0 	pathcount 	pathCount m   ) *���� ��  ��  �  r   B I c   B G b   B E o   B C���� "0 emailconfigfile emailConfigFile o   C D����  0 configfilename configFileName m   E F��
�� 
ctxt o      ���� "0 emailconfigfile emailConfigFile  r   J T c   J R  n  J P!"! I   K P��#���� 0 	read_file  # $��$ o   K L���� "0 emailconfigfile emailConfigFile��  ��  "  f   J K  m   P Q�
� 
ctxt o      �~�~ (0 emailaddressstring emailAddressString %�}% r   U `&'& c   U ^()( n  U \*+* I   V \�|,�{�| 0 splitstring  , -.- o   V W�z�z (0 emailaddressstring emailAddressString. /�y/ m   W X00  ,   �y  �{  +  f   U V) m   \ ]�x
�x 
list' o      �w�w 0 	emaillist 	emailList�}  � 121 l     �v�u�v  �u  2 343 l     �t5�t  5 � � getSourceInformation returns the type, rights type, and copyright notice for the image as a string. If the source is a vendor then that copyright notice is retrieved. Otherwise the book copyright notice is returned.   4 676 i    898 I      �s:�r�s ,0 getsourceinformation getSourceInformation: ;�q; o      �p�p 0 sourcenumber sourceNumber�q  �r  9 k    << =>= p      ?? �o@�o 0 
irissource 
irisSource@ �n�m�n  0 fieldseparator fieldSeparator�m  > ABA q      CC �lD�l "0 sourceordertype sourceOrderTypeD �kE�k "0 vendorcopyright vendorCopyrightE �jF�j $0 sourcerightstype sourceRightsTypeF �i�h�i  0 labelcopyright labelCopyright�h  B GHG O     �IJI O    �KLK k    �MM NON r    PQP o    �g�g 0 sourcenumber sourceNumberQ n      RSR 4    �fT
�f 
ccelT m    UU  
Source No.   S 4    �eV
�e 
cRQTV m    �d�d O WXW I   �cY�b
�c .FMPRFINDnull���    obj Y 4    �aZ
�a 
cwinZ m    �`�` �b  X [�_[ Z    �\]�^^\ l   *_�]_ I   *�\`�[
�\ .coredoexbool        obj ` l   &a�Za n    &bcb 1   $ &�Y
�Y 
vluec n    $ded 4   ! $�Xf
�X 
ccelf m   " #gg  
Order Type   e 1    !�W
�W 
pCRW�Z  �[  �]  ] k   - �hh iji r   - 9klk c   - 7mnm n   - 5opo 1   3 5�V
�V 
vluep n   - 3qrq 4   0 3�Us
�U 
ccels m   1 2tt  
Image Type   r 1   - 0�T
�T 
pCRWn m   5 6�S
�S 
ctxtl o      �R�R "0 sourceimagetype sourceImageTypej uvu l  : :�Qw�Q  w Y Sset sourceImageFormat to cellValue of cell "Image Format" of current record as text   v xyx r   : Fz{z c   : D|}| n   : B~~ 1   @ B�P
�P 
vlue n   : @��� 4   = @�O�
�O 
ccel� m   > ?��  
Order Type   � 1   : =�N
�N 
pCRW} m   B C�M
�M 
ctxt{ o      �L�L "0 sourceordertype sourceOrderTypey ��� r   G X��� c   G V��� n  G T��� I   H T�K��J�K 0 	righttrim 	rightTrim� ��I� n   H P��� 1   N P�H
�H 
vlue� n   H N��� 4   K N�G�
�G 
ccel� m   L M��  Label Copyright   � 1   H K�F
�F 
pCRW�I  �J  �  f   G H� m   T U�E
�E 
ctxt� o      �D�D  0 labelcopyright labelCopyright� ��� Z   Y ����C�� l  Y ^��B� =   Y ^��� o   Y Z�A�A "0 sourceordertype sourceOrderType� m   Z ]��  vendor   �B  � k   a ��� ��� r   a t��� c   a r��� n  a p��� I   b p�@��?�@ 0 	righttrim 	rightTrim� ��>� n   b l��� 1   j l�=
�= 
vlue� n   b j��� 4   e j�<�
�< 
ccel� m   f i��  Vendor Copyright Notice   � 1   b e�;
�; 
pCRW�>  �?  �  f   a b� m   p q�:
�: 
ctxt� o      �9�9 "0 vendorcopyright vendorCopyright� ��8� r   u ���� c   u ���� n  u ���� I   v ��7��6�7 0 	righttrim 	rightTrim� ��5� n   v ���� 1   ~ ��4
�4 
vlue� n   v ~��� 4   y ~�3�
�3 
ccel� m   z }��  Vendor Set No.   � 1   v y�2
�2 
pCRW�5  �6  �  f   u v� m   � ��1
�1 
ctxt� o      �0�0 0 vendorsetnum vendorSetNum�8  �C  � k   � ��� ��� r   � ���� c   � ���� n  � ���� I   � ��/��.�/ 0 	righttrim 	rightTrim� ��-� n   � ���� 1   � ��,
�, 
vlue� n   � ���� 4   � ��+�
�+ 
ccel� m   � ���  Book Copyright   � 1   � ��*
�* 
pCRW�-  �.  �  f   � �� m   � ��)
�) 
ctxt� o      �(�( "0 vendorcopyright vendorCopyright� ��'� r   � ���� c   � ���� m   � ���      � m   � ��&
�& 
ctxt� o      �%�% 0 vendorsetnum vendorSetNum�'  � ��$� r   � ���� c   � ���� n  � ���� I   � ��#��"�# 0 	righttrim 	rightTrim� ��!� n   � ���� 1   � �� 
�  
vlue� n   � ���� 4   � ���
� 
ccel� m   � ���  Rights Type   � 1   � ��
� 
pCRW�!  �"  �  f   � �� m   � ��
� 
ctxt� o      �� $0 sourcerightstype sourceRightsType�$  �^  ^ k   � ��� ��� r   � ���� c   � ���� m   � ���      � m   � ��
� 
ctxt� o      �� "0 sourceimagetype sourceImageType� ��� l  � ����  � ) #set sourceImageFormat to "" as text   � ��� r   � ���� c   � ���� m   � ���      � m   � ��
� 
ctxt� o      ��  0 labelcopyright labelCopyright� ��� r   � ���� c   � ���� m   � ���      � m   � ��
� 
ctxt� o      �� "0 vendorcopyright vendorCopyright� ��� r   � ���� c   � �   m   � �       m   � ��
� 
ctxt� o      �� 0 vendorsetnum vendorSetNum� � r   � � c   � � m   � �       m   � ��
� 
ctxt o      �� $0 sourcerightstype sourceRightsType�  �_  L 4    �	
� 
cDB 	 o    �� 0 
irissource 
irisSourceJ m     �H 
�
 L   � c   � b   �  b   � � b   � � b   � � b   � � b   � � b   � � b   � � o   � ��� "0 sourceimagetype sourceImageType o   � ���  0 fieldseparator fieldSeparator o   � ��
�
 $0 sourcerightstype sourceRightsType o   � ��	�	  0 fieldseparator fieldSeparator o   � ���  0 labelcopyright labelCopyright o   � ���  0 fieldseparator fieldSeparator o   � ��� "0 vendorcopyright vendorCopyright o   � ���  0 fieldseparator fieldSeparator o   � ��� 0 vendorsetnum vendorSetNum m   �
� 
ctxt�  7  l     ���  �    !  l     � "�   " � � getSubjectAuthority retrieves the authority value for each subject term specified in the list passed. A list of authority values is returned that correlates to the list of subjects.   ! #$# i    %&% I      ��'���� *0 getsubjectauthority getSubjectAuthority' (��( o      ���� 0 subjectlist subjectList��  ��  & k     �)) *+* p      ,, ��-�� 0 irissubject irisSubject- ��.�� "0 outputdirectory outputDirectory. ��/�� 0 newline newLine/ ��0�� 0 errorlog errorLog0 ��1�� 0 
errorcount 
errorCount1 ��2�� 0 imagenumber imageNumber2 ������ 0 
worknumber 
workNumber��  + 343 q      55 ��6�� 0 authoritylist authorityList6 ��7�� 0 subjectcount subjectCount7 ��8�� 0 i  8 ������ 0 	authority  ��  4 9:9 O     �;<; O    �=>= k    �?? @A@ r    BCB c    DED J    ����  E m    ��
�� 
listC o      ���� 0 authoritylist authorityListA FGF r    HIH I   ��J��
�� .corecnte****       ****J o    ���� 0 subjectlist subjectList��  I o      ���� 0 subjectcount subjectCountG K��K Y    �L��MN��L k   $ �OO PQP r   $ )RSR c   $ 'TUT m   $ %VV      U m   % &��
�� 
ctxtS o      ���� 0 	authority  Q WXW Q   * �YZ[Y Z   - w\]����\ l  - 3^��^ >   - 3_`_ l  - 1a��a n   - 1bcb 4   . 1��d
�� 
cobjd o   / 0���� 0 i  c o   - .���� 0 subjectlist subjectList��  ` m   1 2ee      ��  ] k   6 sff ghg r   6 Diji c   6 <klk n   6 :mnm 4   7 :��o
�� 
cobjo o   8 9���� 0 i  n o   6 7���� 0 subjectlist subjectListl m   : ;��
�� 
ctxtj n      pqp 4   @ C��r
�� 
ccelr m   A Bss  Subject Term   q 4   < @��t
�� 
cRQTt m   > ?���� h uvu I  E M��w��
�� .FMPRFINDnull���    obj w 4   E I��x
�� 
cwinx m   G H���� ��  v y��y Z   N sz{����z l  N \|��| I  N \��}��
�� .coredoexbool        obj } l  N X~��~ n   N X� 1   T X��
�� 
vlue� n   N T��� 4   Q T���
�� 
ccel� m   R S��  Subject Term   � 1   N Q��
�� 
pCRW��  ��  ��  { r   _ o��� c   _ m��� n   _ k��� 1   g k��
�� 
vlue� n   _ g��� 4   b g���
�� 
ccel� m   c f��  Subject Authority   � 1   _ b��
�� 
pCRW� m   k l��
�� 
ctxt� o      ���� 0 	authority  ��  ��  ��  ��  ��  Z R      ������
�� .ascrerr ****      � ****��  ��  [ k    ��� ��� r    ���� c    ���� m    ���      � m   � ���
�� 
ctxt� o      ���� 0 	authority  � ��� r   � ���� [   � ���� o   � ����� 0 
errorcount 
errorCount� m   � ����� � o      ���� 0 
errorcount 
errorCount� ���� n  � ���� I   � �������� 0 write_to_file  � ��� l  � ����� b   � ���� o   � ����� "0 outputdirectory outputDirectory� o   � ����� 0 errorlog errorLog��  � ��� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� m   � ���      � o   � ����� 0 
errorcount 
errorCount� m   � ��� 	 : (   � o   � ����� 0 imagenumber imageNumber� m   � ���  /   � o   � ����� 0 
worknumber 
workNumber� m   � ��� 1 +) Unable to get authority for subject term    � l  � ����� n   � ���� 4   � ����
�� 
cobj� o   � ����� 0 i  � o   � ����� 0 subjectlist subjectList��  � o   � ����� 0 newline newLine� ���� m   � ���
�� boovtrue��  ��  �  f   � ���  X ���� r   � ���� c   � ���� b   � ���� o   � ����� 0 authoritylist authorityList� o   � ����� 0 	authority  � m   � ���
�� 
list� o      ���� 0 authoritylist authorityList��  �� 0 i  M m    ���� N o    ���� 0 subjectcount subjectCount��  ��  > 4    ���
�� 
cDB � o    ���� 0 irissubject irisSubject< m     �: ���� L   � ��� o   � ����� 0 authoritylist authorityList��  $ ��� l     ������  ��  � ��� l     �����  � � � getSubtypeAuthority retrieves the authority value for each subject subtype specified in the list passed. A list of authority values is returned that correlates to the list of subject subtypes.   � ��� i    ��� I      ������� *0 getsubtypeauthority getSubtypeAuthority� ���� o      ���� 0 subtypelist subtypeList��  ��  � k     ��� ��� p      �� ����� 0 irissubtype irisSubtype� ����� "0 outputdirectory outputDirectory� ����� 0 newline newLine� ����� 0 errorlog errorLog� ����� 0 
errorcount 
errorCount� ����� 0 imagenumber imageNumber� ������ 0 
worknumber 
workNumber��  � ��� q      �� ����� 0 authoritylist authorityList� ����� 0 subtypecount subtypeCount� ����� 0 i  � ������ 0 	authority  ��  � ��� O     ���� O    ���� k    ��� ��� r    ��� c    ��� J    ����  � m    ��
�� 
list� o      ���� 0 authoritylist authorityList� ��� r    ��� I   �����
�� .corecnte****       ****� o    ���� 0 subtypelist subtypeList��  � o      ���� 0 subtypecount subtypeCount� ���� Y    ��������� k   $ ��� ��� r   $ )� � c   $ ' m   $ %       m   % &��
�� 
ctxt  o      �� 0 	authority  �  Q   * � Z   - w	
�~�}	 l  - 3�| >   - 3 l  - 1�{ n   - 1 4   . 1�z
�z 
cobj o   / 0�y�y 0 i   o   - .�x�x 0 subtypelist subtypeList�{   m   1 2      �|  
 k   6 s  r   6 D c   6 < n   6 : 4   7 :�w
�w 
cobj o   8 9�v�v 0 i   o   6 7�u�u 0 subtypelist subtypeList m   : ;�t
�t 
ctxt n       4   @ C�s
�s 
ccel m   A B    Subtype    4   < @�r!
�r 
cRQT! m   > ?�q�q  "#" I  E M�p$�o
�p .FMPRFINDnull���    obj $ 4   E I�n%
�n 
cwin% m   G H�m�m �o  # &�l& Z   N s'(�k�j' l  N \)�i) I  N \�h*�g
�h .coredoexbool        obj * l  N X+�f+ n   N X,-, 1   T X�e
�e 
vlue- n   N T./. 4   Q T�d0
�d 
ccel0 m   R S11  Subtype   / 1   N Q�c
�c 
pCRW�f  �g  �i  ( r   _ o232 c   _ m454 n   _ k676 1   g k�b
�b 
vlue7 n   _ g898 4   b g�a:
�a 
ccel: m   c f;;  	Authority   9 1   _ b�`
�` 
pCRW5 m   k l�_
�_ 
ctxt3 o      �^�^ 0 	authority  �k  �j  �l  �~  �}   R      �]�\�[
�] .ascrerr ****      � ****�\  �[   k    �<< =>= r    �?@? c    �ABA m    �CC      B m   � ��Z
�Z 
ctxt@ o      �Y�Y 0 	authority  > DED r   � �FGF [   � �HIH o   � ��X�X 0 
errorcount 
errorCountI m   � ��W�W G o      �V�V 0 
errorcount 
errorCountE J�UJ n  � �KLK I   � ��TM�S�T 0 write_to_file  M NON l  � �P�RP b   � �QRQ o   � ��Q�Q "0 outputdirectory outputDirectoryR o   � ��P�P 0 errorlog errorLog�R  O STS b   � �UVU b   � �WXW b   � �YZY b   � �[\[ b   � �]^] b   � �_`_ b   � �aba b   � �cdc m   � �ee      d o   � ��O�O 0 
errorcount 
errorCountb m   � �ff 	 : (   ` o   � ��N�N 0 imagenumber imageNumber^ m   � �gg  /   \ o   � ��M�M 0 
worknumber 
workNumberZ m   � �hh , &) Unable to get authority for subtype    X l  � �i�Li n   � �jkj 4   � ��Kl
�K 
cobjl o   � ��J�J 0 i  k o   � ��I�I 0 subtypelist subtypeList�L  V o   � ��H�H 0 newline newLineT m�Gm m   � ��F
�F boovtrue�G  �S  L  f   � ��U   n�En r   � �opo c   � �qrq b   � �sts o   � ��D�D 0 authoritylist authorityListt o   � ��C�C 0 	authority  r m   � ��B
�B 
listp o      �A�A 0 authoritylist authorityList�E  �� 0 i  � m    �@�@ � o    �?�? 0 subtypecount subtypeCount��  ��  � 4    �>u
�> 
cDB u o    �=�= 0 irissubtype irisSubtype� m     �� v�<v L   � �ww o   � ��;�; 0 authoritylist authorityList�<  � xyx l     �:�9�:  �9  y z{z l     �8|�8  |   joinby   { }~} i    � I      �7��6�7 
0 joinby  � ��� o      �5�5 0 somestrings  � ��4� o      �3�3 	0 delim  �4  �6  � k     *�� ��� l     �2��2  � ) # join list of strings by delim char   � ��� Q     '���� k    �� ��� r    ��� n   ��� 1    �1
�1 
txdl� 1    �0
�0 
ascr� o      �/�/ 0 olddelim oldDelim� ��� r   	 ��� o   	 
�.�. 	0 delim  � n     ��� 1    �-
�- 
txdl� 1   
 �,
�, 
ascr� ��� r    ��� c    ��� o    �+�+ 0 somestrings  � m    �*
�* 
TEXT� o      �)�) 
0 retval  � ��(� r    ��� o    �'�' 0 olddelim oldDelim� n     ��� 1    �&
�& 
txdl� 1    �%
�% 
ascr�(  � R      �$�#�"
�$ .ascrerr ****      � ****�#  �"  � r   " '��� o   " #�!�! 0 olddelim oldDelim� n     ��� 1   $ &� 
�  
txdl� 1   # $�
� 
ascr� ��� L   ( *�� o   ( )�� 
0 retval  �  ~ ��� l     ���  �  � ��� l     ���  � a [ listTrim takes a list and trims newline characters from the end of each string in the list   � ��� i    ��� I      ���� 0 listtrim listTrim� ��� o      �� 0 lstvalue lstValue�  �  � k     6�� ��� q      �� ��� 0 newlist newList� ��� 0 numitems numItems� ��� 0 i  � ��� 0 tempitem tempItem�  � ��� r     ��� c     ��� J     ��  � m    �
� 
list� o      �� 0 newlist newList� ��� r    ��� I   ���
� .corecnte****       ****� o    �� 0 lstvalue lstValue�  � o      �
�
 0 numitems numItems� ��� Y    3��	���� k    .�� ��� r    !��� c    ��� n    ��� 4    ��
� 
cobj� o    �� 0 i  � o    �� 0 lstvalue lstValue� m    �
� 
ctxt� o      �� 0 tempitem tempItem� ��� r   " .��� c   " ,��� b   " *��� o   " #�� 0 newlist newList� n  # )��� I   $ )� ����  0 	righttrim 	rightTrim� ���� o   $ %���� 0 tempitem tempItem��  ��  �  f   # $� m   * +��
�� 
list� o      ���� 0 newlist newList�  �	 0 i  � m    ���� � o    ���� 0 numitems numItems�  � ���� L   4 6�� o   4 5���� 0 newlist newList��  � ��� l     ������  ��  � ��� l     �����  � !  reads a file into a string   � ��� i     #��� I      ������� 0 	read_file  � ���� o      ���� 0 the_file  ��  ��  � k     S�� ��� r     ��� c     ��� o     ���� 0 the_file  � m    ��
�� 
TEXT� o      ���� 0 the_file  � ��� r    ��� c    	��� m    ��      � m    ��
�� 
ctxt� o      ���� 0 file_contents  � ��� Q    P   k    7  r     I   ����
�� .rdwropenshor       file 4    ��	
�� 
file	 o    ���� 0 the_file  ��   o      ���� 0 
input_file   

 r    ! l   �� I   ����
�� .rdwrgeofcomp       **** o    ���� 0 
input_file  ��  ��   o      ���� 0 	file_size    r   " 1 l  " /�� I  " /��
�� .rdwrread****        **** o   " #���� 0 
input_file   ��
�� 
deli o   $ %��
�� 
ret  ��
�� 
as   m   & '��
�� 
ctxt ��
�� 
rdfm m   ( )����  ����
�� 
rdto o   * +���� 0 	file_size  ��  ��   o      ���� 0 file_contents   �� I  2 7����
�� .rdwrclosnull���     **** o   2 3���� 0 
input_file  ��  ��   R      ������
�� .ascrerr ****      � ****��  ��   Q   ? P !��  I  B G��"��
�� .rdwrclosnull���     ****" o   B C���� 0 
input_file  ��  ! R      ������
�� .ascrerr ****      � ****��  ��  ��  � #��# L   Q S$$ o   Q R���� 0 file_contents  ��  � %&% l     ������  ��  & '(' l     ��)��  ) ] W rightTrim returns a string value with whitespace characters removed from the end of it   ( *+* i   $ ',-, I      ��.���� 0 	righttrim 	rightTrim. /��/ o      ���� 0 strvalue strValue��  ��  - k     �00 121 p      33 ������ 0 newline newLine��  2 454 q      66 ��7�� 0 strindex strIndex7 ��8�� 0 lastchar lastChar8 ��9��  0 carriagereturn carriageReturn9 ������ 0 	spacechar 	spaceChar��  5 :;: r     	<=< c     >?> l    @��@ I    ��A��
�� .sysontocTEXT       shorA m     ���� ��  ��  ? m    ��
�� 
ctxt= o      ����  0 carriagereturn carriageReturn; BCB r   
 DED c   
 FGF l  
 H��H I  
 ��I��
�� .sysontocTEXT       shorI m   
 ����  ��  ��  G m    ��
�� 
ctxtE o      ���� 0 	spacechar 	spaceCharC JKJ r    LML n    NON 1    ��
�� 
lengO o    ���� 0 strvalue strValueM o      ���� 0 strindex strIndexK P��P Z    �QR��SQ =    TUT o    ���� 0 strindex strIndexU m    ����  R L     "VV o     !���� 0 strvalue strValue��  S k   % �WW XYX r   % +Z[Z n   % )\]\ 4   & )��^
�� 
cha ^ o   ' (���� 0 strindex strIndex] o   % &���� 0 strvalue strValue[ o      ���� 0 lastchar lastCharY _`_ V   , kaba k   D fcc ded Z   D Sfg����f l  D Gh��h ?   D Giji o   D E���� 0 strindex strIndexj m   E F����  ��  g r   J Oklk \   J Mmnm o   J K���� 0 strindex strIndexn m   K L���� l o      ���� 0 strindex strIndex��  ��  e o��o Z   T fpq��rp l  T Ws��s >   T Wtut o   T U���� 0 strindex strIndexu m   U V����  ��  q r   Z `vwv n   Z ^xyx 4   [ ^��z
�� 
cha z o   \ ]���� 0 strindex strIndexy o   Z [���� 0 strvalue strValuew o      ���� 0 lastchar lastChar��  r r   c f{|{ m   c d}}      | o      ���� 0 lastchar lastChar��  b G   0 C~~ G   0 ;��� l  0 3���� =   0 3��� o   0 1���� 0 lastchar lastChar� o   1 2���� 0 newline newLine��  � l  6 9���� =   6 9��� o   6 7���� 0 lastchar lastChar� o   7 8����  0 carriagereturn carriageReturn��   l  > A���� =   > A��� o   > ?���� 0 lastchar lastChar� o   ? @���� 0 	spacechar 	spaceChar��  ` ���� Z   l ������� l  l o���� >   l o��� o   l m�� 0 lastchar lastChar� m   m n��      ��  � L   r �� n   r ~��� 7  s }�~��
�~ 
ctxt� m   w y�}�} � o   z |�|�| 0 strindex strIndex� o   r s�{�{ 0 strvalue strValue��  � L   � ��� m   � ���      ��  ��  + ��� l     �z�y�z  �y  � ��� l     �x��x  � � � sends an email message using Unix mail command therefore it uses the user logged in as the from address. So the first parameter   � ��� l     �w��w  � #  to this function is ignored.   � ��� i   ( +��� I      �v��u�v $0 sendemailmessage sendEmailMessage� ��� o      �t�t 0 fromaddress fromAddress� ��� o      �s�s 0 toaddresslist toAddressList� ��� o      �r�r 0 messagefile messageFile� ��q� o      �p�p (0 attachmentfilelist attachmentFileList�q  �u  � k     ��� ��� p      �� �o�n�o 0 newline newLine�n  � ��� q      �� �m��m 0 sendmail  � �l��l 0 message  � �k��k 0 i  � �j�i�j 0 commandline commandLine�i  � ��h� O     ���� k    �� ��� r    ��� c    ��� b    ��� b    ��� m    �� + %mail -s "IRIS work and image export"    � n   ��� I    �g��f�g 
0 joinby  � ��� o    �e�e 0 toaddresslist toAddressList� ��d� m    ��  ,   �d  �f  �  f    � o    �c�c 0 newline newLine� m    �b
�b 
ctxt� o      �a�a 0 sendmail  � ��� r    ��� c    ��� n   ��� I    �`��_�` 0 	read_file  � ��^� o    �]�] 0 messagefile messageFile�^  �_  �  f    � m    �\
�\ 
ctxt� o      �[�[ 0 message  � ��� r    *��� c    (��� b    &��� b    $��� b    "��� o     �Z�Z 0 message  � o     !�Y�Y 0 newline newLine� m   " #�� � zPlease contact someone in DLPS if you need assistance in resolving any issues you may have with the content of this email.   � o   $ %�X�X 0 newline newLine� m   & '�W
�W 
ctxt� o      �V�V 0 message  � ��� l  + +�U�T�U  �T  � ��� l  + +�S��S  � A ; If there are attachments then there must have been errors.   � ��� Z   + m���R�Q� l  + 2��P� >   + 2��� l  + 0��O� I  + 0�N��M
�N .corecnte****       ****� o   + ,�L�L (0 attachmentfilelist attachmentFileList�M  �O  � m   0 1�K�K  �P  � k   5 i�� ��� r   5 @��� c   5 >��� b   5 <��� b   5 :��� b   5 8��� o   5 6�J�J 0 message  � o   6 7�I�I 0 newline newLine� m   8 9   @ :Below are the contents of the error logs for this project.   � o   : ;�H�H 0 newline newLine� m   < =�G
�G 
ctxt� o      �F�F 0 message  �  l  A A�E�E   "  Add attachments to the file    �D Y   A i�C�B k   O d 	
	 l  O U r   O U l  O S�A n   O S 4   P S�@
�@ 
cobj o   Q R�?�? 0 i   o   O P�>�> (0 attachmentfilelist attachmentFileList�A   o      �=�= 0 
targetfile 
targetFile  as text   
 �< r   V d c   V b b   V ` b   V ^ o   V W�;�; 0 message   n  W ] I   X ]�:�9�: 0 	read_file   �8 o   X Y�7�7 0 
targetfile 
targetFile�8  �9    f   W X o   ^ _�6�6 0 newline newLine m   ` a�5
�5 
ctxt o      �4�4 0 message  �<  �C 0 i   m   D E�3�3  l  E J �2  I  E J�1!�0
�1 .corecnte****       ****! o   E F�/�/ (0 attachmentfilelist attachmentFileList�0  �2  �B  �D  �R  �Q  � "#" r   n y$%$ c   n w&'& b   n u()( b   n s*+* b   n q,-, m   n o..  echo '   - o   o p�.�. 0 message  + m   q r// 
 ' |    ) o   s t�-�- 0 sendmail  ' m   u v�,
�, 
ctxt% o      �+�+ 0 commandline commandLine# 0�*0 I  z �)1�(
�) .sysoexecTEXT���     TEXT1 o   z {�'�' 0 commandline commandLine�(  �*  � m     22�null     ߀�� 1�
Finder.appd in as the from address. So the first parameter��@  MACS   alis    Z  Main                       ��#H+   1�
Finder.app                                                      5�g~5        ����  	                CoreServices    � #c      �gą     1� * (  +Main:System:Library:CoreServices:Finder.app    
 F i n d e r . a p p  
  M a i n  &System/Library/CoreServices/Finder.app  / ��  �h  � 343 l     �&�%�&  �%  4 565 l     �$7�$  7   sends an email message   6 898 i   , /:;: I      �#<�"�# ,0 sendemailmessage_old sendEmailMessage_old< =>= o      �!�! 0 fromaddress fromAddress> ?@? o      � �  0 toaddresslist toAddressList@ ABA o      �� 0 messagefile messageFileB C�C o      �� (0 attachmentfilelist attachmentFileList�  �"  ; k     �DD EFE p      GG ��� 0 newline newLine�  F HIH q      JJ �K� 0 messagebody messageBodyK �L� 0 
newmessage 
newMessageL ��� 0 i  �  I M�M O     �NON k    �PP QRQ r    STS c    UVU n   
WXW I    
�Y�� 0 	read_file  Y Z�Z o    �� 0 messagefile messageFile�  �  X  f    V m   
 �
� 
ctxtT o      �� 0 messagebody messageBodyR [\[ r    ]^] c    _`_ b    aba b    cdc b    efe b    ghg o    �� 0 messagebody messageBodyh o    �� 0 newline newLinef o    �� 0 newline newLined m    ii � zPlease contact someone in DLPS if you need assistance in resolving any issues you may have with the content of this email.   b o    �� 0 newline newLine` m    �
� 
ctxt^ o      �
�
 0 messagebody messageBody\ jkj l   �	��	  �  k lml l   �n�  n A ; If there are attachments then there must have been errors.   m opo Z    6qr��q l   $s�s >    $tut l   "v�v I   "�w�
� .corecnte****       ****w o    � �  (0 attachmentfilelist attachmentFileList�  �  u m   " #����  �  r r   ' 2xyx c   ' 0z{z b   ' .|}| b   ' ,~~ b   ' *��� o   ' (���� 0 messagebody messageBody� o   ( )���� 0 newline newLine m   * +�� " Attached are the error logs.   } o   , -���� 0 newline newLine{ m   . /��
�� 
ctxty o      ���� 0 messagebody messageBody�  �  p ��� l  7 7������  ��  � ��� r   7 I��� I  7 G�����
�� .corecrel****      � null��  � ����
�� 
kocl� m   9 :��
�� 
bcke� �����
�� 
prdt� K   ; C�� ����
�� 
subj� m   < =��   IRIS work and image export   � ����
�� 
ctnt� o   > ?���� 0 messagebody messageBody� �����
�� 
sndr� o   @ A���� 0 fromaddress fromAddress��  ��  � o      ���� 0 
newmessage 
newMessage� ��� l  J J�����  � 0 * Add email addresses to the recipient list   � ��� Y   J ��������� k   X �� ��� r   X `��� l  X ^���� n   X ^��� 4   Y ^���
�� 
cobj� o   \ ]���� 0 i  � o   X Y���� 0 toaddresslist toAddressList��  � o      ���� 0 emailaddress emailAddress� ���� O  a ��� I  e ~�����
�� .corecrel****      � null��  � ����
�� 
kocl� m   g j��
�� 
trcp� ����
�� 
insh� n   m s���  :   r s� 2  m r��
�� 
trcp� �����
�� 
prdt� K   t z�� �����
�� 
radd� o   w x���� 0 emailaddress emailAddress��  ��  � o   a b���� 0 
newmessage 
newMessage��  �� 0 i  � m   M N���� � l  N S���� I  N S�����
�� .corecnte****       ****� o   N O���� 0 toaddresslist toAddressList��  ��  ��  � ��� l  � ������  � "  Add attachments to the file   � ��� O   � ���� Y   � ��������� k   � ��� ��� l  � ���� r   � ���� l  � ����� n   � ���� 4   � ����
�� 
cobj� o   � ����� 0 i  � o   � ����� (0 attachmentfilelist attachmentFileList��  � o      ���� 0 
targetfile 
targetFile�  as text   � ���� O   � ���� k   � ��� ��� l  � ������  � m gmake new attachment with properties {file name:targetFile} at after the last word of the last paragraph   � ���� I  � ������
�� .corecrel****      � null��  � ����
�� 
kocl� m   � ���
�� 
atts� ����
�� 
prdt� K   � ��� �����
�� 
atfn� o   � ����� 0 
targetfile 
targetFile��  � �����
�� 
insh� n   � ���� 9   � ���
�� 
insl� l  � ����� 4  � ����
�� 
cpar� m   � ���������  ��  ��  � 1   � ���
�� 
ctnt��  �� 0 i  � m   � ����� � l  � ����� I  � ������
�� .corecnte****       ****� o   � ����� (0 attachmentfilelist attachmentFileList��  ��  ��  � o   � ����� 0 
newmessage 
newMessage� ���� Q   � ����� I  � ������
�� .emsgsendnull���     mssg� o   � ����� 0 
newmessage 
newMessage��  � R      ������
�� .ascrerr ****      � ****��  ��  � I  � ������
�� .sysodlogaskr        TEXT� m   � ���  Unable to send email!   ��  ��  O m     ���null     ߀��   Mail.appyou may have with the content of this email.amete��Р��emal   alis    ,  Main                       ��#H+     Mail.app                                                         wS���        ����  	                Applications    � #c      ��2         Main:Applications:Mail.app    M a i l . a p p  
  M a i n  Applications/Mail.app   / ��  �  9 ��� l     ������  ��  � ��� l     �����  � &   splitstring - copied from Steve   � ��� i   0 3��� I      ������� 0 splitstring  � ��� o      ���� 0 
somestring  � ���� o      ���� 	0 delim  ��  ��  � k     *�� ��� l     �����  � "  split string by delim char	   � ��� Q     '���� k    �� ��� r       n    1    ��
�� 
txdl 1    ��
�� 
ascr o      ���� 0 olddelim oldDelim�  r   	  o   	 
���� 	0 delim   n     	 1    ��
�� 
txdl	 1   
 ��
�� 
ascr 

 r     n     2   ��
�� 
citm o    ���� 0 
somestring   o      ���� 0 retvals   �� r     o    ���� 0 olddelim oldDelim n      1    ��
�� 
txdl 1    ��
�� 
ascr��  � R      ������
�� .ascrerr ****      � ****��  ��  � r   " ' o   " #���� 0 olddelim oldDelim n      1   $ &��
�� 
txdl 1   # $��
�� 
ascr� �� L   ( * o   ( )���� 0 retvals  ��  �  l     ������  ��    l     ����   g a updateProjectOnWeb will pass status information in the URL via Safari that is used to update it.     !  i   4 7"#" I      ��$���� (0 updateprojectonweb updateProjectOnWeb$ %&% o      ���� 0 projname projName& '(' o      ���� 0 stepnum stepNum( )*) o      ���� 0 	starttime 	startTime* +,+ o      ���� 0 
finishtime 
finishTime, -��- o      �� 0 
errorcount 
errorCount��  ��  # k     w.. /0/ p      11 �~�}�~ .0 imageprojectstatusurl imageProjectStatusURL�}  0 232 q      44 �|5�| 0 urltext urlText5 �{�z�{ 0 i  �z  3 676 r     	898 c     :;: b     <=< b     >?> o     �y�y .0 imageprojectstatusurl imageProjectStatusURL? m    @@  project=   = o    �x�x 0 projname projName; m    �w
�w 
ctxt9 o      �v�v 0 urltext urlText7 ABA Z   
 %CD�u�tC G   
 EFE l  
 G�sG =   
 HIH o   
 �r�r 0 stepnum stepNumI m    �q�q �s  F l   J�pJ =    KLK o    �o�o 0 stepnum stepNumL m    �n�n �p  D r    !MNM c    OPO b    QRQ b    STS o    �m�m 0 urltext urlTextT m    UU  &step=   R o    �l�l 0 stepnum stepNumP m    �k
�k 
ctxtN o      �j�j 0 urltext urlText�u  �t  B VWV Z   & 9XY�i�hX l  & )Z�gZ >   & )[\[ o   & '�f�f 0 	starttime 	startTime\ m   ' (]]      �g  Y r   , 5^_^ c   , 3`a` b   , 1bcb b   , /ded o   , -�e�e 0 urltext urlTexte m   - .ff  	&started=   c o   / 0�d�d 0 	starttime 	startTimea m   1 2�c
�c 
ctxt_ o      �b�b 0 urltext urlText�i  �h  W ghg Z   : Mij�a�`i l  : =k�_k >   : =lml o   : ;�^�^ 0 
finishtime 
finishTimem m   ; <nn      �_  j r   @ Iopo c   @ Gqrq b   @ Ests b   @ Cuvu o   @ A�]�] 0 urltext urlTextv m   A Bww  
&finished=   t o   C D�\�\ 0 
finishtime 
finishTimer m   E F�[
�[ 
ctxtp o      �Z�Z 0 urltext urlText�a  �`  h xyx r   N Wz{z c   N U|}| b   N S~~ b   N Q��� o   N O�Y�Y 0 urltext urlText� m   O P��  &errorCount=    o   Q R�X�X 0 
errorcount 
errorCount} m   S T�W
�W 
ctxt{ o      �V�V 0 urltext urlTexty ��U� O   X w��� k   \ v�� ��� I  \ a�T��S
�T .GURLGURLnull��� ��� TEXT� o   \ ]�R�R 0 urltext urlText�S  � ��� Y   b p��Q���P� l  l l�O��O  � 4 . give the web browser some time before closing   �Q 0 i  � m   e f�N�N � m   f g�M�M 
�P  � ��L� I  q v�K�J�I
�K .aevtquitnull���    obj �J  �I  �L  � m   X Y���null     ߀��   
Safari.appsed to update it.agraphtent of ���` email.amete��Р��sfri   alis    4  Main                       ��#H+     
Safari.app                                                       �Z�1k        ����  	                Applications    � #c      �1��         Main:Applications:Safari.app   
 S a f a r i . a p p  
  M a i n  Applications/Safari.app   / ��  �U  ! ��� l     �H�G�H  �G  � ��� l     �F��F  � \ V Copied from http://bbs.applescript.net/viewtopic.php?t=5667&highlight=write+text+file   � ��� i   8 ;��� I      �E��D�E 0 write_to_file  � ��� o      �C�C 0 the_file  � ��� o      �B�B 0 
the_string  � ��A� o      �@�@ 0 	appending  �A  �D  � k     R�� ��� r     ��� c     ��� o     �?�? 0 the_file  � m    �>
�> 
TEXT� o      �=�= 0 the_file  � ��<� Q    R���� k   	 9�� ��� r   	 ��� I  	 �;��
�; .rdwropenshor       file� 4   	 �:�
�: 
file� o    �9�9 0 the_file  � �8��7
�8 
perm� m    �6
�6 boovtrue�7  � o      �5�5 0 
write_file  � ��� Z   '���4�3� =    ��� o    �2�2 0 	appending  � m    �1
�1 boovfals� I   #�0��
�0 .rdwrseofnull���     ****� o    �/�/ 0 
write_file  � �.��-
�. 
set2� m    �,�,  �-  �4  �3  � ��� I  ( 3�+��
�+ .rdwrwritnull���     ****� o   ( )�*�* 0 
the_string  � �)��
�) 
refn� o   * +�(�( 0 
write_file  � �'��
�' 
wrat� m   , -�&
�& rdwreof � �%��$
�% 
as  � m   . /�#
�# 
utf8�$  � ��"� I  4 9�!�� 
�! .rdwrclosnull���     ****� o   4 5�� 0 
write_file  �   �"  � R      ���
� .ascrerr ****      � ****�  �  � Q   A R���� I  D I���
� .rdwrclosnull���     ****� o   D E�� 0 
write_file  �  � R      ���
� .ascrerr ****      � ****�  �  �  �<  � ��� l     ���  �  � ��� l     ���  � ^ X Make sure that the pogo.lib dropbox is mounted. If not then prompt the user to connect.   � ��� l  � ���� r   � ���� I  � ����
� .earslvolutxt  P ��� null�  �  � o      �� 0 
volumelist 
volumeList�  � ��� l  � ���� r   � ���� m   � ��
� boovfals� o      �
�
 ,0 dropboxvolumemounted dropboxVolumeMounted�  � ��� l  � ���	� Y   � ������� Z   � ������ l  � ���� =   � ���� n   � ���� 4   � ���
� 
cobj� o   � ��� 0 i  � o   � ��� 0 
volumelist 
volumeList� m   � ���  dropbox   �  � r   � ���� m   � �� 
�  boovtrue� o      ���� ,0 dropboxvolumemounted dropboxVolumeMounted�  �  � 0 i  � m   � ����� � I  � ������
�� .corecnte****       ****� o   � ����� 0 
volumelist 
volumeList��  �  �	  � ��� l  ����� Z   �������� l  � ����� H   � ��� o   � ����� ,0 dropboxvolumemounted dropboxVolumeMounted��  � I  �����
�� .aevtmvolnull���     TEXT� m   �� ) #smb://pogo.lib.virginia.edu/dropbox   ��  ��  ��  ��  � ��� l     ������  ��  � ��� l     �����  � L FGet the list of work numbers and project name that were just exported.   � ��� l ���� r  ��� c  	 		  n 			 I  ��	���� 0 	read_file  	 	��	 b  			 o  ���� "0 outputdirectory outputDirectory	 o  ���� "0 inputworknofile inputWorkNoFile��  ��  	  f  	 m  ��
�� 
ctxt� o      ���� 0 inputtextfile inputTextFile��  � 				 l .	
��	
 r  .			 c  *			 n (			 I  (��	���� 0 splitstring  	 			 o  !���� 0 inputtextfile inputTextFile	 	��	 o  !$���� 0 newline newLine��  ��  	  f  	 m  ()��
�� 
list	 o      ���� 0 inputrecords inputRecords��  		 			 l /7	��	 r  /7			 c  /3			 J  /1����  	 m  12��
�� 
list	 o      ����  0 worknumberlist workNumberList��  	 			 l 8�	��	 Y  8�	��	 	!��	 k  H�	"	" 	#	$	# r  HV	%	&	% c  HR	'	(	' n  HP	)	*	) 4  KP��	+
�� 
cobj	+ o  NO���� 0 linenum lineNum	* o  HK���� 0 inputrecords inputRecords	( m  PQ��
�� 
ctxt	& o      ���� 0 linedata lineData	$ 	,	-	, r  Wh	.	/	. c  Wd	0	1	0 I  Wb��	2���� 0 splitstring  	2 	3	4	3 o  X[���� 0 linedata lineData	4 	5��	5 o  [^����  0 fieldseparator fieldSeparator��  ��  	1 m  bc��
�� 
list	/ o      ���� 
0 fields  	- 	6��	6 Z  i�	7	8����	7 l iu	9��	9 >  iu	:	;	: l iq	<��	< n  iq	=	>	= 4  lq��	?
�� 
cobj	? m  op���� 	> o  il���� 
0 fields  ��  	; m  qt	@	@      ��  	8 k  x�	A	A 	B	C	B r  x�	D	E	D c  x�	F	G	F b  x�	H	I	H o  x{����  0 worknumberlist workNumberList	I l {�	J��	J n  {�	K	L	K 4  ~���	M
�� 
cobj	M m  ������ 	L o  {~���� 
0 fields  ��  	G m  ����
�� 
list	E o      ����  0 worknumberlist workNumberList	C 	N��	N r  ��	O	P	O c  ��	Q	R	Q n  ��	S	T	S 4  ����	U
�� 
cobj	U m  ������ 	T o  ������ 
0 fields  	R m  ����
�� 
ctxt	P o      ���� 0 projectname projectName��  ��  ��  ��  �� 0 linenum lineNum	  m  ;<���� 	! I <C��	V��
�� .corecnte****       ****	V o  <?���� 0 inputrecords inputRecords��  ��  ��  	 	W	X	W l ��	Y��	Y r  ��	Z	[	Z I ����	\��
�� .corecnte****       ****	\ o  ������  0 worknumberlist workNumberList��  	[ o      ���� "0 worknumbercount workNumberCount��  	X 	]	^	] l     ������  ��  	^ 	_	`	_ l ��	a��	a r  ��	b	c	b c  ��	d	e	d b  ��	f	g	f o  ������ 0 projectname projectName	g m  ��	h	h  .images   	e m  ����
�� 
ctxt	c o      ����  0 outputfilename outputFilename��  	` 	i	j	i l     ������  ��  	j 	k	l	k l     ��	m��  	m b \ Prompt the user about the project and work count for which image records will be processed.   	l 	n	o	n l ��	p��	p I ����	q	r
�� .sysodlogaskr        TEXT	q b  ��	s	t	s b  ��	u	v	u b  ��	w	x	w b  ��	y	z	y m  ��	{	{ , &Proceed with exporting image data for    	z o  ������ "0 worknumbercount workNumberCount	x m  ��	|	|   works found in the    	v o  ������ 0 projectname projectName	t m  ��	}	}  	 project?   	r ��	~��
�� 
givu	~ m  ������  ��  ��  	o 		�	 l     ������  ��  	� 	�	�	� l ��	���	� t  ��	�	�	� k  ��	�	� 	�	�	� O  �
$	�	�	� k  �
#	�	� 	�	�	� r  ��	�	�	� I ��������
�� .misccurdldt    ��� null��  ��  	� o      ���� 0 	starttime 	startTime	� 	�	�	� r  ��	�	�	� c  ��	�	�	� n ��	�	�	� I  ����	����� &0 getdatetimestring getDateTimeString	� 	���	� o  ������ 0 	starttime 	startTime��  ��  	�  f  ��	� m  ����
�� 
ctxt	� o      ���� 0 startdatetime startDateTime	� 	�	�	� n �	�	�	� I  ���	����� (0 updateprojectonweb updateProjectOnWeb	� 	�	�	� o  � ���� 0 projectname projectName	� 	�	�	� m   ���� 	� 	�	�	� o  ���� 0 startdatetime startDateTime	� 	�	�	� m  	�	�      	� 	���	� m  ����  ��  ��  	�  f  ��	� 	�	�	� l ������  ��  	� 	�	�	� n !	�	�	� I  !��	����� 0 write_to_file  	� 	�	�	� l 	���	� b  	�	�	� o  ���� "0 outputdirectory outputDirectory	� o  ���� 40 outputstatisticsfilename outputStatisticsFilename��  	� 	�	�	� b  	�	�	� m  	�	�  Image Export - Step 2   	� o  ���� 0 newline newLine	� 	���	� m  ��
�� boovtrue��  ��  	�  f  	� 	�	�	� n "8	�	�	� I  #8��	����� 0 write_to_file  	� 	�	�	� l #(	��	� b  #(	�	�	� o  #$�~�~ "0 outputdirectory outputDirectory	� o  $'�}�} 40 outputstatisticsfilename outputStatisticsFilename�  	� 	�	�	� b  (3	�	�	� b  (/	�	�	� m  (+	�	�  Start=   	� o  +.�|�| 0 	starttime 	startTime	� o  /2�{�{ 0 newline newLine	� 	��z	� m  34�y
�y boovtrue�z  ��  	�  f  "#	� 	�	�	� l 99�x	��x  	� � z Generate a header line to the export file so it is available as a reference if anyone needs to manually examine the file.   	� 	�	�	� r  9�	�	�	� c  9�	�	�	� b  9�	�	�	� b  9�	�	�	� b  9�	�	�	� b  9�	�	�	� b  9�	�	�	� b  9�	�	�	� b  9�	�	�	� b  9�	�	�	� b  9�	�	�	� b  9�	�	�	� b  9�	�	�	� b  9�	�	�	� b  9�	�	�	� b  9�	�	�	� b  9�	�	�	� b  9�	�	�	� b  9�	�	�	� b  9�	�	�	� b  9�	�	�	� b  9�	�	�	� b  9�	�	�	� b  9�
 

  b  9�


 b  9�


 b  9�


 b  9�

	
 b  9�




 b  9�


 b  9�


 b  9�


 b  9�


 b  9|


 b  9x


 b  9t


 b  9p


 b  9l


 b  9h


 b  9d
 
!
  b  9`
"
#
" b  9\
$
%
$ b  9X
&
'
& b  9T
(
)
( b  9P
*
+
* b  9L
,
-
, b  9H
.
/
. b  9D
0
1
0 b  9@
2
3
2 m  9<
4
4  Work Number   
3 o  <?�w�w  0 fieldseparator fieldSeparator
1 m  @C
5
5  Work Project Name   
/ o  DG�v�v  0 fieldseparator fieldSeparator
- m  HK
6
6  Image Number   
+ o  LO�u�u  0 fieldseparator fieldSeparator
) m  PS
7
7  	Image PID   
' o  TW�t�t  0 fieldseparator fieldSeparator
% m  X[
8
8  Image Project Name   
# o  \_�s�s  0 fieldseparator fieldSeparator
! m  `c
9
9  Digital Filename   
 o  dg�r�r  0 fieldseparator fieldSeparator
 m  hk
:
:  Image Color   
 o  lo�q�q  0 fieldseparator fieldSeparator
 m  ps
;
;  	View Type   
 o  tw�p�p  0 fieldseparator fieldSeparator
 m  x{
<
<  View Description   
 o  |�o�o  0 fieldseparator fieldSeparator
 m  ��
=
=  	View Date   
 o  ���n�n  0 fieldseparator fieldSeparator
 m  ��
>
>  Image Subjects   
 o  ���m�m  0 fieldseparator fieldSeparator
	 m  ��
?
?   Image Subjects Authorities   
 o  ���l�l  0 fieldseparator fieldSeparator
 m  ��
@
@  Image Subject Subtypes   
 o  ���k�k  0 fieldseparator fieldSeparator
 m  ��
A
A ( "Image Subject Subtypes Authorities   	� o  ���j�j  0 fieldseparator fieldSeparator	� m  ��
B
B  Image Export Date   	� o  ���i�i  0 fieldseparator fieldSeparator	� m  ��
C
C  Image Vendor Code   	� o  ���h�h  0 fieldseparator fieldSeparator	� m  ��
D
D  Image Identifier Type   	� o  ���g�g  0 fieldseparator fieldSeparator	� m  ��
E
E  Image Identifier Number   	� o  ���f�f  0 fieldseparator fieldSeparator	� m  ��
F
F  Source Number   	� o  ���e�e  0 fieldseparator fieldSeparator	� m  ��
G
G  Source Image Type   	� o  ���d�d  0 fieldseparator fieldSeparator	� m  ��
H
H  Source Rights Type   	� o  ���c�c  0 fieldseparator fieldSeparator	� m  ��
I
I  Source Label Copyright   	� o  ���b�b  0 fieldseparator fieldSeparator	� m  ��
J
J  Source Vendor Copyright   	� o  ���a�a  0 fieldseparator fieldSeparator	� m  ��
K
K  Source Vendor Set No.   	� o  ���`�` 0 newline newLine	� m  ���_
�_ 
ctxt	� o      �^�^ 0 
headerline 
headerLine	� 
L
M
L n �
N
O
N I   �]
P�\�] 0 write_to_file  
P 
Q
R
Q l  
S�[
S b   
T
U
T o   �Z�Z "0 outputdirectory outputDirectory
U o  �Y�Y  0 outputfilename outputFilename�[  
R 
V
W
V o  �X�X 0 
headerline 
headerLine
W 
X�W
X m  	�V
�V boovfals�W  �\  
O  f  � 
M 
Y
Z
Y n 
[
\
[ I  �U
]�T�U 0 write_to_file  
] 
^
_
^ l 
`�S
` b  
a
b
a o  �R�R "0 outputdirectory outputDirectory
b o  �Q�Q 0 errorlog errorLog�S  
_ 
c
d
c m  
e
e      
d 
f�P
f m  �O
�O boovfals�P  �T  
\  f  
Z 
g
h
g l �N�M�N  �M  
h 
i
j
i l �L
k�L  
k A ;open irisDirectory & irisDigital with password irisPassword   
j 
l
m
l I &�K
n�J
�K .GURLGURLnull��� ��� TEXT
n b  "
o
p
o o  �I�I (0 irisremotelocation irisRemoteLocation
p o  !�H�H 0 irisdigital irisDigital�J  
m 
q
r
q r  '4
s
t
s l '0
u�G
u N  '0
v
v 4  '/�F
w
�F 
cDB 
w o  +.�E�E 0 irisdigital irisDigital�G  
t o      �D�D 0 irisdigitaldb irisDigitalDB
r 
x
y
x Z  5W
z
{�C�B
z = 5>
|
}
| l 5<
~�A
~ I 5<�@
�?
�@ .coredoexbool        obj 
 o  58�>�> 0 irisdigitaldb irisDigitalDB�?  �A  
} m  <=�=
�= boovfals
{ k  AS
�
� 
�
�
� I AP�<
��;
�< .sysodlogaskr        TEXT
� b  AL
�
�
� b  AH
�
�
� m  AD
�
� % There is a problem finding the    
� o  DG�:�: 0 irisdigital irisDigital
� m  HK
�
� F @ file. Click Cancel and resolve this, then run the script again.   �;  
� 
��9
� L  QS�8�8  �9  �C  �B  
y 
�
�
� l XX�7
��7  
� @ :open irisDirectory & irisSource with password irisPassword   
� 
�
�
� I Xa�6
��5
�6 .GURLGURLnull��� ��� TEXT
� b  X]
�
�
� o  XY�4�4 (0 irisremotelocation irisRemoteLocation
� o  Y\�3�3 0 
irissource 
irisSource�5  
� 
�
�
� r  bo
�
�
� l bk
��2
� N  bk
�
� 4  bj�1
�
�1 
cDB 
� o  fi�0�0 0 
irissource 
irisSource�2  
� o      �/�/ 0 irissourcedb irisSourceDB
� 
�
�
� Z  p�
�
��.�-
� = py
�
�
� l pw
��,
� I pw�+
��*
�+ .coredoexbool        obj 
� o  ps�)�) 0 irissourcedb irisSourceDB�*  �,  
� m  wx�(
�( boovfals
� k  |�
�
� 
�
�
� I |��'
��&
�' .sysodlogaskr        TEXT
� b  |�
�
�
� b  |�
�
�
� m  |
�
� % There is a problem finding the    
� o  ��%�% 0 
irissource 
irisSource
� m  ��
�
� F @ file. Click Cancel and resolve this, then run the script again.   �&  
� 
��$
� L  ���#�#  �$  �.  �-  
� 
�
�
� l ���"
��"  
� A ;open irisDirectory & irisSubject with password irisPassword   
� 
�
�
� I ���!
�� 
�! .GURLGURLnull��� ��� TEXT
� b  ��
�
�
� o  ���� (0 irisremotelocation irisRemoteLocation
� o  ���� 0 irissubject irisSubject�   
� 
�
�
� r  ��
�
�
� l ��
��
� N  ��
�
� 4  ���
�
� 
cDB 
� o  ���� 0 irissubject irisSubject�  
� o      �� 0 irissubjectdb irisSubjectDB
� 
�
�
� Z  ��
�
���
� = ��
�
�
� l ��
��
� I ���
��
� .coredoexbool        obj 
� o  ���� 0 irissubjectdb irisSubjectDB�  �  
� m  ���
� boovfals
� k  ��
�
� 
�
�
� I ���
��
� .sysodlogaskr        TEXT
� b  ��
�
�
� b  ��
�
�
� m  ��
�
� % There is a problem finding the    
� o  ���� 0 irissubject irisSubject
� m  ��
�
� F @ file. Click Cancel and resolve this, then run the script again.   �  
� 
��
� L  ����  �  �  �  
� 
�
�
� l ���
��  
� A ;open irisDirectory & irisSubtype with password irisPassword   
� 
�
�
� I ���
��
� .GURLGURLnull��� ��� TEXT
� b  ��
�
�
� o  ���
�
 (0 irisremotelocation irisRemoteLocation
� o  ���	�	 0 irissubtype irisSubtype�  
� 
�
�
� r  ��
�
�
� l ��
��
� N  ��
�
� 4  ���
�
� 
cDB 
� o  ���� 0 irissubtype irisSubtype�  
� o      �� 0 irissubtypedb irisSubtypeDB
� 
�
�
� Z  �
�
���
� = ��
�
�
� l ��
��
� I ���
�� 
� .coredoexbool        obj 
� o  ������ 0 irissubtypedb irisSubtypeDB�   �  
� m  ����
�� boovfals
� k  �
�
� 
�
�
� I ���
���
�� .sysodlogaskr        TEXT
� b  ��
�
�
� b  ��
�
�
� m  ��
�
� % There is a problem finding the    
� o  ������ 0 irissubtype irisSubtype
� m  ��
�
� F @ file. Click Cancel and resolve this, then run the script again.   ��  
� 
���
� L  ����  ��  �  �  
� 
�
�
� l 		��
���  
� B <open irisDirectory & irisSurrogat with password irisPassword   
� 
�
�
� I 	��
���
�� .GURLGURLnull��� ��� TEXT
� b  	
�
�
� o  	
���� (0 irisremotelocation irisRemoteLocation
� o  
���� 0 irissurrogat irisSurrogat��  
� 
�
�
� r   
�
�
� l 
���
� N  
�
� 4  ��
�
�� 
cDB 
� o  ���� 0 irissurrogat irisSurrogat��  
� o      ����  0 irissurrogatdb irisSurrogatDB
�    Z  !C���� = !* l !(�� I !(����
�� .coredoexbool        obj  o  !$����  0 irissurrogatdb irisSurrogatDB��  ��   m  ()��
�� boovfals k  -? 	
	 I -<����
�� .sysodlogaskr        TEXT b  -8 b  -4 m  -0 % There is a problem finding the     o  03���� 0 irissurrogat irisSurrogat m  47 F @ file. Click Cancel and resolve this, then run the script again.   ��  
 �� L  =?����  ��  ��  ��    l DD����   W Q Loop through each work number and identify the image numbers associated with it.     Y  D	����� k  P	�  r  P\ n  PX !  4  SX��"
�� 
cobj" o  VW���� 0 	workindex 	workIndex! o  PS����  0 worknumberlist workNumberList o      ���� 0 
worknumber 
workNumber #$# r  ]e%&% c  ]a'(' J  ]_����  ( m  _`��
�� 
list& o      ���� "0 imagenumberlist imageNumberList$ )*) l ff��+��  + A ;open irisDirectory & irisWSLinks with password irisPassword   * ,-, I fo��.��
�� .GURLGURLnull��� ��� TEXT. b  fk/0/ o  fg���� (0 irisremotelocation irisRemoteLocation0 o  gj���� 0 iriswslinks irisWSLinks��  - 121 r  p}343 l py5��5 N  py66 4  px��7
�� 
cDB 7 o  tw���� 0 iriswslinks irisWSLinks��  4 o      ���� 0 iriswslinksdb irisWSLinksDB2 898 Z  ~�:;����: = ~�<=< l ~�>��> I ~���?��
�� .coredoexbool        obj ? o  ~����� 0 iriswslinksdb irisWSLinksDB��  ��  = m  ����
�� boovfals; k  ��@@ ABA I ����C��
�� .sysodlogaskr        TEXTC b  ��DED b  ��FGF m  ��HH % There is a problem finding the    G o  ������ 0 iriswslinks irisWSLinksE m  ��II F @ file. Click Cancel and resolve this, then run the script again.   ��  B J��J L  ������  ��  ��  ��  9 KLK O  ��MNM k  ��OO PQP r  ��RSR c  ��TUT l ��V��V 6 ��WXW n  ��YZY 1  ����
�� 
ID  Z 2  ����
�� 
crowX l ��[��[ =  ��\]\ n  ��^_^ 1  ����
�� 
vlue_ 4  ����`
�� 
ccel` m  ��aa  Work No.   ] o  ������ 0 
worknumber 
workNumber��  ��  U m  ����
�� 
listS o      ���� 0 	imagelist 	imageListQ bcb r  ��ded I ����f��
�� .corecnte****       ****f o  ������ 0 	imagelist 	imageList��  e o      ���� 0 
imagecount 
imageCountc g��g Z  ��hi��jh l ��k��k ?  ��lml o  ������ 0 
imagecount 
imageCountm m  ������  ��  i k  �inn opo r  ��qrq c  ��sts J  ������  t m  ����
�� 
listr o      ���� "0 imagenumberlist imageNumberListp u��u Y  �iv��wx��v Q  �dyz{y k  �8|| }~} r  �� l ����� N  ��� 5  ������
�� 
crow� l ���� c  ��� n  
��� 4  
���
�� 
cobj� o  	���� 0 wsindex wsIndex� o  ���� 0 	imagelist 	imageList� m  
��
�� 
long��  
�� kfrmID  ��  � o      ���� 0 wslinkrecord wslinkRecord~ ��� r  *��� n  &��� 1  "&��
�� 
vlue� n  "��� 4  "���
�� 
ccel� m  !��  Surrogate No.   � o  ���� 0 wslinkrecord wslinkRecord� o      ���� 0 imagenumber imageNumber� ���� r  +8��� c  +4��� b  +2��� o  +.���� "0 imagenumberlist imageNumberList� o  .1���� 0 imagenumber imageNumber� m  23��
�� 
list� o      ���� "0 imagenumberlist imageNumberList��  z R      ������
�� .ascrerr ****      � ****��  ��  { k  @d�� ��� r  @I��� [  @E��� o  @C���� 0 
errorcount 
errorCount� m  CD���� � o      ���� 0 
errorcount 
errorCount� ���� n Jd��� I  Kd������� 0 write_to_file  � ��� l KP���� b  KP��� o  KL���� "0 outputdirectory outputDirectory� o  LO���� 0 errorlog errorLog��  � ��� b  P_��� b  P[��� b  PW��� m  PS��  ERROR: Work number    � o  SV���� 0 
worknumber 
workNumber� m  WZ�� 0 * has problems accessing its image numbers.   � o  [^���� 0 newline newLine� ���� m  _`��
�� boovtrue��  ��  �  f  JK��  �� 0 wsindex wsIndexw m  ������ x o  ������ 0 
imagecount 
imageCount��  ��  ��  j n l���� I  m�������� 0 write_to_file  � ��� l mr���� b  mr��� o  mn���� "0 outputdirectory outputDirectory� o  nq���� 40 outputstatisticsfilename outputStatisticsFilename��  � ��� b  r���� b  r}��� b  ry��� m  ru��  WARNING: Work number    � o  ux���� 0 
worknumber 
workNumber� m  y|�� + % does not have any associated images.   � o  }����� 0 newline newLine� ���� m  ����
�� boovtrue��  ��  �  f  lm��  N 4  ����
� 
cDB � o  ���~�~ 0 iriswslinks irisWSLinksL ��� r  ����� I ���}��|
�} .corecnte****       ****� o  ���{�{ "0 imagenumberlist imageNumberList�|  � o      �z�z 0 
imagecount 
imageCount� ��y� Z  �	����x�w� l ����v� ?  ����� o  ���u�u 0 
imagecount 
imageCount� m  ���t�t  �v  � O  �	���� Y  �	���s���r� k  �	��� ��� r  ����� n  ����� 4  ���q�
�q 
cobj� o  ���p�p 0 
imageindex 
imageIndex� o  ���o�o "0 imagenumberlist imageNumberList� o      �n�n 0 imgnum imgNum� ��� r  ����� o  ���m�m 0 imgnum imgNum� n      ��� 4  ���l�
�l 
ccel� m  ����  Surrogate No.   � 4  ���k�
�k 
cRQT� m  ���j�j � ��� I ���i��h
�i .FMPRFINDnull���    obj � 4  ���g�
�g 
cwin� m  ���f�f �h  � ��� Z  �	���e�� l ����d� =  ����� l ����c� n  ����� 1  ���b
�b 
vlue� n  ����� 4  ���a�
�a 
ccel� m  ����  Surrogate No.   � 1  ���`
�` 
pCRW�c  � o  ���_�_ 0 imgnum imgNum�d  � k  ���� � � r  � n  � 1   �^
�^ 
vlue n  �  4  � �]
�] 
ccel m  ��  Surrogate No.    1  ���\
�\ 
pCRW o      �[�[ 0 imagenumber imageNumber  	
	 r  	" n 	 I  
�Z�Y�Z 0 	righttrim 	rightTrim �X n  
 1  �W
�W 
vlue n  
 4  �V
�V 
ccel m    Source::Image Type    1  
�U
�U 
pCRW�X  �Y    f  	
 o      �T�T 0 	imagetype 	imageType
  r  #< n #8 I  $8�S�R�S 0 	righttrim 	rightTrim �Q n  $4  1  04�P
�P 
vlue  n  $0!"! 4  )0�O#
�O 
ccel# m  ,/$$  Approved   " 1  $)�N
�N 
pCRW�Q  �R    f  #$ o      �M�M 0 imageapproved imageApproved %&% r  =K'(' c  =G)*) n =E+,+ I  >E�L-�K�L  0 getdigitalfile getDigitalFile- .�J. o  >A�I�I 0 imagenumber imageNumber�J  �K  ,  f  =>* m  EF�H
�H 
list( o      �G�G 0 digitalmedia digitalMedia& /0/ r  LZ121 c  LV343 n  LT565 4  OT�F7
�F 
cobj7 m  RS�E�E 6 o  LO�D�D 0 digitalmedia digitalMedia4 m  TU�C
�C 
ctxt2 o      �B�B ,0 imagedigitalfilename imageDigitalFilename0 898 r  [v:;: c  [r<=< n [p>?> I  \p�A@�@�A 0 	righttrim 	rightTrim@ A�?A n  \lBCB 1  hl�>
�> 
vlueC n  \hDED 4  ah�=F
�= 
ccelF m  dgGG  Color   E 1  \a�<
�< 
pCRW�?  �@  ?  f  [\= m  pq�;
�; 
ctxt; o      �:�: 0 
imagecolor 
imageColor9 HIH r  w�JKJ c  w�LML n  w�NON 1  ���9
�9 
vlueO n  w�PQP 4  |��8R
�8 
ccelR m  �SS  	View Type   Q 1  w|�7
�7 
pCRWM m  ���6
�6 
listK o      �5�5 0 imageviewtype imageViewTypeI TUT r  ��VWV n ��XYX I  ���4Z�3�4 0 listtrim listTrimZ [�2[ o  ���1�1 0 imageviewtype imageViewType�2  �3  Y  f  ��W o      �0�0 0 imageviewtype imageViewTypeU \]\ r  ��^_^ c  ��`a` n ��bcb I  ���/d�.�/ 0 	righttrim 	rightTrimd e�-e n  ��fgf 1  ���,
�, 
vlueg n  ��hih 4  ���+j
�+ 
ccelj m  ��kk  View Description   i 1  ���*
�* 
pCRW�-  �.  c  f  ��a m  ���)
�) 
ctxt_ o      �(�( ,0 imageviewdescription imageViewDescription] lml r  ��non c  ��pqp n ��rsr I  ���'t�&�' 0 	righttrim 	rightTrimt u�%u n  ��vwv 1  ���$
�$ 
vluew n  ��xyx 4  ���#z
�# 
ccelz m  ��{{  	View Date   y 1  ���"
�" 
pCRW�%  �&  s  f  ��q m  ���!
�! 
ctxto o      � �  0 imageviewdate imageViewDatem |}| r  ��~~ c  ����� n  ����� 1  ���
� 
vlue� n  ����� 4  ����
� 
ccel� m  ����  Subjects   � 1  ���
� 
pCRW� m  ���
� 
list o      �� 0 imagesubjects imageSubjects} ��� r  ����� n ����� I  ������ 0 listtrim listTrim� ��� o  ���� 0 imagesubjects imageSubjects�  �  �  f  ��� o      �� 0 imagesubjects imageSubjects� ��� r  ���� c  ���� n ����� I  ������ *0 getsubjectauthority getSubjectAuthority� ��� o  ���� 0 imagesubjects imageSubjects�  �  �  f  ��� m  � �
� 
list� o      �� .0 imagesubjectauthority imageSubjectAuthority� ��� r  ��� n ��� I  ���� 0 listtrim listTrim� ��� o  
�� .0 imagesubjectauthority imageSubjectAuthority�  �  �  f  � o      �� .0 imagesubjectauthority imageSubjectAuthority� ��� r  )��� c  %��� n  #��� 1  #�

�
 
vlue� n  ��� 4  �	�
�	 
ccel� m  ��  Subject Subtypes   � 1  �
� 
pCRW� m  #$�
� 
list� o      �� ,0 imagesubjectsubtypes imageSubjectSubtypes� ��� r  *6��� n *2��� I  +2���� 0 listtrim listTrim� ��� o  +.�� ,0 imagesubjectsubtypes imageSubjectSubtypes�  �  �  f  *+� o      �� ,0 imagesubjectsubtypes imageSubjectSubtypes� ��� r  7E��� c  7A��� n 7?��� I  8?� ����  *0 getsubjectauthority getSubjectAuthority� ���� o  8;���� ,0 imagesubjectsubtypes imageSubjectSubtypes��  ��  �  f  78� m  ?@��
�� 
list� o      ���� .0 imagesubtypeauthority imageSubtypeAuthority� ��� r  FR��� n FN��� I  GN������� 0 listtrim listTrim� ���� o  GJ���� .0 imagesubtypeauthority imageSubtypeAuthority��  ��  �  f  FG� o      ���� .0 imagesubtypeauthority imageSubtypeAuthority� ��� r  Sn��� c  Sj��� n Sh��� I  Th������� 0 	righttrim 	rightTrim� ���� n  Td��� 1  `d��
�� 
vlue� n  T`��� 4  Y`���
�� 
ccel� m  \_�� 	 PID   � 1  TY��
�� 
pCRW��  ��  �  f  ST� m  hi��
�� 
ctxt� o      ���� 0 imagepid imagePID� ��� r  o���� n  o��� 1  {��
�� 
vlue� n  o{��� 4  t{���
�� 
ccel� m  wz��  
Source No.   � 1  ot��
�� 
pCRW� o      ���� &0 imagesourcenumber imageSourceNumber� ��� r  ����� c  ����� n ����� I  ��������� 0 	righttrim 	rightTrim� ���� n  ����� 1  ����
�� 
vlue� n  ����� 4  �����
�� 
ccel� m  ����  Vendor Code   � 1  ����
�� 
pCRW��  ��  �  f  ��� m  ����
�� 
ctxt� o      ���� "0 imagevendorcode imageVendorCode� ��� r  ����� c  ����� n ����� I  ��������� 0 	righttrim 	rightTrim� ���� n  ����� 1  ����
�� 
vlue� n  ����� 4  ���� 
�� 
ccel  m  ��  Identifier Type   � 1  ����
�� 
pCRW��  ��  �  f  ��� m  ����
�� 
ctxt� o      ���� *0 imageidentifiertype imageIdentifierType�  r  �� c  �� n ��	 I  ����
���� 0 	righttrim 	rightTrim
 �� n  �� 1  ����
�� 
vlue n  �� 4  ����
�� 
ccel m  ��  Identifier Number    1  ����
�� 
pCRW��  ��  	  f  �� m  ����
�� 
ctxt o      ���� .0 imageidentifiernumber imageIdentifierNumber  r  �� c  �� n �� I  �������� 0 	righttrim 	rightTrim �� n  �� 1  ����
�� 
vlue n  �� 4  ���� 
�� 
ccel  m  ��!!  Project Name    1  ����
�� 
pCRW��  ��    f  �� m  ����
�� 
ctxt o      ���� $0 imageprojectname imageProjectName "#" r  �$%$ n  �&'& 1   ��
�� 
vlue' n  � ()( 4  � ��*
�� 
ccel* m  ��++  Export Date   ) 1  ����
�� 
pCRW% o      ���� "0 imageexportdate imageExportDate# ,��, r  	�-.- c  	�/0/ b  	�121 b  	�343 b  	�565 b  	�787 b  	�9:9 b  	�;<; b  	�=>= b  	�?@? b  	�ABA b  	�CDC b  	�EFE b  	�GHG b  	|IJI b  	pKLK b  	lMNM b  	`OPO b  	\QRQ b  	PSTS b  	LUVU b  	HWXW b  	DYZY b  	@[\[ b  	<]^] b  	0_`_ b  	,aba b  	(cdc b  	$efe b  	 ghg b  	iji b  	klk b  	mnm b  	opo o  	���� 0 imagenumber imageNumberp o  ����  0 fieldseparator fieldSeparatorn o  ���� 0 imagepid imagePIDl o  ����  0 fieldseparator fieldSeparatorj o  ���� $0 imageprojectname imageProjectNameh o  ����  0 fieldseparator fieldSeparatorf o   #���� ,0 imagedigitalfilename imageDigitalFilenamed o  $'����  0 fieldseparator fieldSeparatorb o  (+���� 0 
imagecolor 
imageColor` o  ,/����  0 fieldseparator fieldSeparator^ n 0;qrq I  1;��s���� 
0 joinby  s tut o  14���� 0 imageviewtype imageViewTypeu v��v o  47����  0 valueseparator valueSeparator��  ��  r  f  01\ o  <?����  0 fieldseparator fieldSeparatorZ o  @C���� ,0 imageviewdescription imageViewDescriptionX o  DG����  0 fieldseparator fieldSeparatorV o  HK���� 0 imageviewdate imageViewDateT o  LO����  0 fieldseparator fieldSeparatorR n P[wxw I  Q[��y���� 
0 joinby  y z{z o  QT���� 0 imagesubjects imageSubjects{ |��| o  TW����  0 valueseparator valueSeparator��  ��  x  f  PQP o  \_����  0 fieldseparator fieldSeparatorN n `k}~} I  ak������ 
0 joinby   ��� o  ad���� .0 imagesubjectauthority imageSubjectAuthority� ���� o  dg����  0 valueseparator valueSeparator��  ��  ~  f  `aL o  lo����  0 fieldseparator fieldSeparatorJ n p{��� I  q{������� 
0 joinby  � ��� o  qt���� ,0 imagesubjectsubtypes imageSubjectSubtypes� ���� o  tw����  0 valueseparator valueSeparator��  ��  �  f  pqH o  |����  0 fieldseparator fieldSeparatorF n ����� I  ��������� 
0 joinby  � ��� o  ������ .0 imagesubtypeauthority imageSubtypeAuthority� ���� o  ������  0 valueseparator valueSeparator��  ��  �  f  ��D o  ������  0 fieldseparator fieldSeparatorB o  ������ "0 imageexportdate imageExportDate@ o  ������  0 fieldseparator fieldSeparator> o  ������ "0 imagevendorcode imageVendorCode< o  ������  0 fieldseparator fieldSeparator: o  ������ *0 imageidentifiertype imageIdentifierType8 o  ������  0 fieldseparator fieldSeparator6 o  ������ .0 imageidentifiernumber imageIdentifierNumber4 o  ������  0 fieldseparator fieldSeparator2 o  ������ &0 imagesourcenumber imageSourceNumber0 m  ����
�� 
ctxt. o      ���� *0 imagemetadatastring imageMetadataString��  �e  � k  �	�� ��� r  ����� c  ����� m  ����      � m  ����
�� 
ctxt� o      ���� 0 imageapproved imageApproved� ��� r  ����� c  ����� m  ����      � m  ����
�� 
ctxt� o      ���� 0 	imagetype 	imageType� ��� r  ����� c  ����� m  ����      � m  ����
�� 
ctxt� o      ���� ,0 imagedigitalfilename imageDigitalFilename� ��� r  ����� c  ����� m  ����      � m  ����
�� 
ctxt� o      ���� &0 imagesourcenumber imageSourceNumber� ��� r  ����� c  ����� m  ����      � m  ����
�� 
ctxt� o      ���� "0 imagevendorcode imageVendorCode� ��� r  ����� c  ����� m  ����      � m  ����
�� 
ctxt� o      ���� $0 imageprojectname imageProjectName� ���� r  �	��� c  ����� m  ����      � m  ����
�� 
ctxt� o      �� *0 imagemetadatastring imageMetadataString��  � ��� l 		�~��~  � A ; Only export images that have been approved and have a PID.   � ��}� Z  		����|�{� F  		��� l 		
��z� >  		
��� o  		�y�y 0 imageapproved imageApproved� m  			��      �z  � l 		��x� >  		��� o  		�w�w 0 imagepid imagePID� m  		��      �x  � k  		��� ��� l 		�v��v  � = 7 and only work with slide or digital image type records   � ��u� Z  		����t�s� G  		0��� l 		"��r� =  		"��� o  		�q�q 0 	imagetype 	imageType� m  		!��  slide   �r  � l 	%	,��p� =  	%	,��� o  	%	(�o�o 0 	imagetype 	imageType� m  	(	+��  digital image   �p  � Z  	3	����n�m� l 	3	:��l� >  	3	:��� o  	3	6�k�k ,0 imagedigitalfilename imageDigitalFilename� m  	6	9��      �l  � k  	=	��� ��� r  	=	K��� c  	=	G��� n 	=	E��� I  	>	E�j��i�j ,0 getsourceinformation getSourceInformation� ��h� o  	>	A�g�g &0 imagesourcenumber imageSourceNumber�h  �i  �  f  	=	>� m  	E	F�f
�f 
ctxt� o      �e�e ,0 sourcemetadatastring sourceMetadataString� ��� l 	L	L�d��d  � B < Write out the image information with the current work data.   � ��� r  	L	q��� c  	L	m��� b  	L	k��� b  	L	g��� b  	L	c� � b  	L	_ b  	L	[ b  	L	W b  	L	S o  	L	O�c�c 0 
worknumber 
workNumber o  	O	R�b�b  0 fieldseparator fieldSeparator o  	S	V�a�a 0 projectname projectName o  	W	Z�`�`  0 fieldseparator fieldSeparator o  	[	^�_�_ *0 imagemetadatastring imageMetadataString  o  	_	b�^�^  0 fieldseparator fieldSeparator� o  	c	f�]�] ,0 sourcemetadatastring sourceMetadataString� o  	g	j�\�\ 0 newline newLine� m  	k	l�[
�[ 
ctxt� o      �Z�Z 0 metadataline metadataLine� 	
	 n 	r	� I  	s	��Y�X�Y 0 write_to_file    l 	s	x�W b  	s	x o  	s	t�V�V "0 outputdirectory outputDirectory o  	t	w�U�U  0 outputfilename outputFilename�W    o  	x	{�T�T 0 metadataline metadataLine �S m  	{	|�R
�R boovtrue�S  �X    f  	r	s
  r  	�	� [  	�	� o  	�	��Q�Q (0 exportedimagecount exportedImageCount m  	�	��P�P  o      �O�O (0 exportedimagecount exportedImageCount  l 	�	��N�N   E ? Determine if this image is a new one based on the project name    �M Z  	�	� !�L�K  l 	�	�"�J" =  	�	�#$# o  	�	��I�I $0 imageprojectname imageProjectName$ o  	�	��H�H 0 projectname projectName�J  ! r  	�	�%&% [  	�	�'(' o  	�	��G�G &0 projectimagecount projectImageCount( m  	�	��F�F & o      �E�E &0 projectimagecount projectImageCount�L  �K  �M  �n  �m  �t  �s  �u  �|  �{  �}  �s 0 
imageindex 
imageIndex� m  ���D�D � o  ���C�C 0 
imagecount 
imageCount�r  � 4  ���B)
�B 
cDB ) o  ���A�A 0 irissurrogat irisSurrogat�x  �w  �y  �� 0 	workindex 	workIndex m  GH�@�@  o  HK�?�? "0 worknumbercount workNumberCount��   *+* r  	�	�,-, I 	�	��>�=�<
�> .misccurdldt    ��� null�=  �<  - o      �;�; 0 endtime endTime+ ./. n 	�	�010 I  	�	��:2�9�: 0 write_to_file  2 343 l 	�	�5�85 b  	�	�676 o  	�	��7�7 "0 outputdirectory outputDirectory7 o  	�	��6�6 40 outputstatisticsfilename outputStatisticsFilename�8  4 898 b  	�	�:;: b  	�	�<=< m  	�	�>>  Exported Image Count=   = o  	�	��5�5 (0 exportedimagecount exportedImageCount; o  	�	��4�4 0 newline newLine9 ?�3? m  	�	��2
�2 boovtrue�3  �9  1  f  	�	�/ @A@ n 	�	�BCB I  	�	��1D�0�1 0 write_to_file  D EFE l 	�	�G�/G b  	�	�HIH o  	�	��.�. "0 outputdirectory outputDirectoryI o  	�	��-�- 40 outputstatisticsfilename outputStatisticsFilename�/  F JKJ b  	�	�LML b  	�	�NON m  	�	�PP  Project Image Count=   O o  	�	��,�, &0 projectimagecount projectImageCountM o  	�	��+�+ 0 newline newLineK Q�*Q m  	�	��)
�) boovtrue�*  �0  C  f  	�	�A RSR n 	�
TUT I  	�
�(V�'�( 0 write_to_file  V WXW l 	�	�Y�&Y b  	�	�Z[Z o  	�	��%�% "0 outputdirectory outputDirectory[ o  	�	��$�$ 40 outputstatisticsfilename outputStatisticsFilename�&  X \]\ b  	�
^_^ b  	�
`a` m  	�	�bb  Error Count=   a o  	�
�#�# 0 
errorcount 
errorCount_ o  

�"�" 0 newline newLine] c�!c m  

� 
�  boovtrue�!  �'  U  f  	�	�S d�d n 

#efe I  

#�g�� 0 write_to_file  g hih l 

j�j b  

klk o  

�� "0 outputdirectory outputDirectoryl o  

�� 40 outputstatisticsfilename outputStatisticsFilename�  i mnm b  

opo b  

qrq m  

ss 
 End=   r o  

�� 0 endtime endTimep o  

�� 0 newline newLinen t�t m  

�
� boovtrue�  �  f  f  

�  	� m  ���	� uvu l 
%
%���  �  v wxw l 
%
%�y�  y _ Y If errors have occurred then make sure the error logs are attached to the email message.   x z{z r  
%
-|}| c  
%
)~~ J  
%
'��   m  
'
(�
� 
list} o      �� ,0 emailfileattachments emailFileAttachments{ ��� r  
.
>��� c  
.
:��� n 
.
8��� I  
/
8���� 0 	read_file  � ��� b  
/
4��� o  
/
0�� "0 outputdirectory outputDirectory� o  
0
3�� 0 workserrorlog worksErrorLog�  �  �  f  
.
/� m  
8
9�

�
 
ctxt� o      �	�	 0 workerrorfile workErrorFile� ��� r  
?
P��� c  
?
L��� n 
?
J��� I  
@
J���� 0 splitstring  � ��� o  
@
C�� 0 workerrorfile workErrorFile� ��� o  
C
F�� 0 newline newLine�  �  �  f  
?
@� m  
J
K�
� 
list� o      �� 0 workerrorlist workErrorList� ��� r  
Q
V��� m  
Q
R��  � o      � �   0 workerrorcount workErrorCount� ��� Y  
W
��������� Z  
g
�������� l 
g
s���� >  
g
s��� l 
g
o���� n  
g
o��� 4  
j
o���
�� 
cobj� o  
m
n���� 0 i  � o  
g
j���� 0 workerrorlist workErrorList��  � m  
o
r��      ��  � r  
v
��� [  
v
{��� o  
v
y����  0 workerrorcount workErrorCount� m  
y
z���� � o      ����  0 workerrorcount workErrorCount��  ��  �� 0 i  � m  
Z
[���� � I 
[
b�����
�� .corecnte****       ****� o  
[
^���� 0 workerrorlist workErrorList��  ��  � ��� Z  
�
�������� l 
�
����� >  
�
���� o  
�
�����  0 workerrorcount workErrorCount� m  
�
�����  ��  � k  
�
��� ��� r  
�
���� c  
�
���� b  
�
���� o  
�
����� "0 outputdirectory outputDirectory� o  
�
����� 0 workserrorlog worksErrorLog� m  
�
���
�� 
ctxt� o      ���� 0 	errorfile 	errorFile� ���� r  
�
���� c  
�
���� b  
�
���� o  
�
����� ,0 emailfileattachments emailFileAttachments� l 
�
����� 4  
�
����
�� 
alis� o  
�
����� 0 	errorfile 	errorFile��  � m  
�
���
�� 
list� o      ���� ,0 emailfileattachments emailFileAttachments��  ��  ��  � ��� Z  
�
�������� l 
�
����� >  
�
���� o  
�
����� 0 
errorcount 
errorCount� m  
�
�����  ��  � k  
�
��� ��� r  
�
���� c  
�
���� b  
�
���� o  
�
����� "0 outputdirectory outputDirectory� o  
�
����� 0 errorlog errorLog� m  
�
���
�� 
ctxt� o      ���� 0 	errorfile 	errorFile� ���� r  
�
���� c  
�
���� b  
�
���� o  
�
����� ,0 emailfileattachments emailFileAttachments� l 
�
����� 4  
�
����
�� 
alis� o  
�
����� 0 	errorfile 	errorFile��  � m  
�
���
�� 
list� o      ���� ,0 emailfileattachments emailFileAttachments��  ��  ��  � ��� l 
�
�������  ��  � ��� l 
�
������  � N H Send email indicating the results of the export of work and image data.   � ��� r  
�
���� c  
�
���� b  
�
���� o  
�
����� "0 outputdirectory outputDirectory� o  
�
����� 40 outputstatisticsfilename outputStatisticsFilename� m  
�
���
�� 
ctxt� o      ���� 0 emailbodyfile emailBodyFile� ��� I  
�
�������� $0 sendemailmessage sendEmailMessage� ��� o  
�
����� $0 fromemailaddress fromEmailAddress� ��� o  
�
����� (0 toemailaddresslist toEmailAddressList� ��� o  
�
����� 0 emailbodyfile emailBodyFile� ���� o  
�
����� ,0 emailfileattachments emailFileAttachments��  ��  � ��� l 
�
�������  ��  � ��� l 
�
������  � * $Remove the files used to store data.   � ��� O  
�W   k  V  I ����
�� .coredeloobj        obj  o  ���� 0 emailbodyfile emailBodyFile��    Y  	*��	
�� I %����
�� .coredeloobj        obj  l !�� n  ! 4  !��
�� 
cobj o   ���� 0 filecnt fileCnt o  ���� ,0 emailfileattachments emailFileAttachments��  ��  �� 0 filecnt fileCnt	 m  ���� 
 I ����
�� .corecnte****       **** o  ���� ,0 emailfileattachments emailFileAttachments��  ��    l ++������  ��    l ++����   Y S If there were no errors, then delete the file containing the list of work numbers.    �� Z  +V���� l +<�� F  +< l +0�� =  +0 o  +.����  0 workerrorcount workErrorCount m  ./����  ��   l 38�� =  38 !  o  36���� 0 
errorcount 
errorCount! m  67����  ��  ��   k  ?R"" #$# r  ?J%&% c  ?F'(' b  ?D)*) o  ?@���� "0 outputdirectory outputDirectory* o  @C���� "0 inputworknofile inputWorkNoFile( m  DE��
�� 
ctxt& o      ���� 0 workfile workFile$ +��+ I KR��,��
�� .coredeloobj        obj , o  KN���� 0 workfile workFile��  ��  ��  ��  ��   m  
�
�2� -.- l XX������  ��  . /0/ r  Xf121 c  Xb343 n X`565 I  Y`��7���� &0 getdatetimestring getDateTimeString7 8��8 o  Y\���� 0 endtime endTime��  ��  6  f  XY4 m  `a��
�� 
ctxt2 o      ���� 0 enddatetime endDateTime0 9:9 n g{;<; I  h{��=���� (0 updateprojectonweb updateProjectOnWeb= >?> o  hk���� 0 projectname projectName? @A@ m  kl���� A BCB m  loDD      C EFE o  or���� 0 enddatetime endDateTimeF G��G o  ru���� 0 
errorcount 
errorCount��  ��  <  f  gh: HIH l ||������  ��  I J��J O  |�KLK I ����MN
�� .sysodlogaskr        TEXTM m  ��OO : 4IRIS Image export to tab delimited file is complete!   N ��PQ
�� 
btnsP J  ��RR S��S m  ��TT  OK   ��  Q ��UV
�� 
dfltU m  ��WW  OK   V ��X��
�� 
givuX m  ������  ��  L m  |���  	� m  ������p��  	� Y��Y l     ��~�  �~  ��       �}Z[\]^_`abcdefghij�}  Z �|�{�z�y�x�w�v�u�t�s�r�q�p�o�n�m�| &0 getdatetimestring getDateTimeString�{  0 getdigitalfile getDigitalFile�z 40 getemaildistributionlist getEmailDistributionList�y ,0 getsourceinformation getSourceInformation�x *0 getsubjectauthority getSubjectAuthority�w *0 getsubtypeauthority getSubtypeAuthority�v 
0 joinby  �u 0 listtrim listTrim�t 0 	read_file  �s 0 	righttrim 	rightTrim�r $0 sendemailmessage sendEmailMessage�q ,0 sendemailmessage_old sendEmailMessage_old�p 0 splitstring  �o (0 updateprojectonweb updateProjectOnWeb�n 0 write_to_file  
�m .aevtoappnull  �   � ****[ �l�k�jkl�i�l &0 getdatetimestring getDateTimeString�k �hm�h m  �g�g 0 
dateobject 
dateObject�j  k �f�e�d�c�b�a�`�_�^�]�\�[�Z�f 0 
dateobject 
dateObject�e 0 d  �d 0 daystr dayStr�c 0 m  �b 0 monstr monStr�a 0 y  �` 0 secs  �_ 0 hrstr hrStr�^ 0 min  �] 0 minstr minStr�\ 0 secstr secStr�[  0 datetimestring dateTimeString�Z 0 h  l +�Y�X<�W�V�UQ�T[�Se�Ro�Qy�P��O��N��M��L��K��J��I�H�G���F-KLMNO
�Y 
day �X 

�W 
ctxt
�V 
mnth
�U 
jan 
�T 
feb 
�S 
mar 
�R 
apr 
�Q 
may 
�P 
jun 
�O 
jul 
�N 
aug 
�M 
sep 
�L 
oct 
�K 
nov 
�J 
dec 
�I 
year
�H 
time�G�F <�i���,E�O�� �%�&E�Y ��&E�O��,E�O��  �E�Y ���  �E�Y ���  �E�Y ���  �E�Y }��  �E�Y q��  
a E�Y c�a   
a E�Y S�a   
a E�Y C�a   
a E�Y 3�a   
a E�Y #�a   
a E�Y �a   
a E�Y hO�a ,E�O�a ,E�O�a  ,�a "E�O�a #E�O�� a  �%�&E�Y ��&E�Y a !E�O�a " ,�a ""E�O�a "#E�O�� a #�%�&E�Y ��&E�Y a $E�O�� a %�%�&E�Y ��&E�O�a &%�%a '%�%a (%�%a )%�%a *%�%�&E�\ �EX�D�Cno�B�E  0 getdigitalfile getDigitalFile�D �Ap�A p  �@�@ 0 imagenumber imageNumber�C  n �?�>�=�<�? 0 imagenumber imageNumber�> "0 digitalfilename digitalFileName�= 0 digitalformat digitalFormat�< 0 
digitalurl 
digitalURLo ��;�:�9�8q�7�6�5��4�3��2������1
�; 
cDB �: 0 irisdigital irisDigital
�9 
cRQT
�8 
ccel
�7 
cwin
�6 .FMPRFINDnull���    obj 
�5 
pCRW
�4 
vlue
�3 .coredoexbool        obj 
�2 
ctxt
�1 
list�B {� l*��/ d�*�k/��/FO*�k/j O*�,��/�,j  +*�,��/�,�&E�O*�,��/�,�&E�O*�,��/�,�&E�Y a �&E�Oa �&E�Oa �&E�UUO���mva &] �0��/�.qr�-�0 40 getemaildistributionlist getEmailDistributionList�/ �,s�, s  �+�+  0 configfilename configFileName�.  q �*�)�(�'�&�%�$�#�*  0 configfilename configFileName�) 0 pathtoscript pathToScript�( 0 pathlist pathList�' 0 	pathcount 	pathCount�& "0 emailconfigfile emailConfigFile�% 0 i  �$ (0 emailaddressstring emailAddressString�# 0 	emaillist 	emailListr �"�!� �������0
�" 
rtyp
�! 
ctxt
�  .earsffdralis        afdr� 0 splitstring  
� 
list
� .corecnte****       ****
� 
cobj� 0 	read_file  �- a)��l E�O)��l+ �&E�O�j E�O��&E�O k�kkh ���/%�%�&E�[OY��O��%�&E�O)�k+ 
�&E�O)��l+ �&E�^ �9��tu�� ,0 getsourceinformation getSourceInformation� �v� v  �� 0 sourcenumber sourceNumber�  t �������� 0 sourcenumber sourceNumber� "0 sourceordertype sourceOrderType� "0 vendorcopyright vendorCopyright� $0 sourcerightstype sourceRightsType�  0 labelcopyright labelCopyright� "0 sourceimagetype sourceImageType� 0 vendorsetnum vendorSetNumu �����
U�	��g��t��������������
� 
cDB � 0 
irissource 
irisSource
� 
cRQT
�
 
ccel
�	 
cwin
� .FMPRFINDnull���    obj 
� 
pCRW
� 
vlue
� .coredoexbool        obj 
� 
ctxt� 0 	righttrim 	rightTrim�  0 fieldseparator fieldSeparator�� �*��/ ۠*�k/��/FO*�k/j O*�,��/�,j  �*�,��/�,�&E�O*�,��/�,�&E�O)*�,��/�,k+ �&E�O�a   ,)*�,�a /�,k+ �&E�O)*�,�a /�,k+ �&E�Y )*�,�a /�,k+ �&E�Oa �&E�O)*�,�a /�,k+ �&E�Y )a �&E�Oa �&E�Oa �&E�Oa �&E�Oa �&E�UUO�_ %�%_ %�%_ %�%_ %�%�&_ �&� ��wx��� *0 getsubjectauthority getSubjectAuthority�  ��y�� y  ���� 0 subjectlist subjectList��  w ������������ 0 subjectlist subjectList�� 0 authoritylist authorityList�� 0 subjectcount subjectCount�� 0 i  �� 0 	authority  x !���������V����e����s�����������������������������������
�� 
cDB �� 0 irissubject irisSubject
�� 
list
�� .corecnte****       ****
�� 
ctxt
�� 
cobj
�� 
cRQT
�� 
ccel
�� 
cwin
�� .FMPRFINDnull���    obj 
�� 
pCRW
�� 
vlue
�� .coredoexbool        obj ��  ��  �� 0 
errorcount 
errorCount�� "0 outputdirectory outputDirectory�� 0 errorlog errorLog�� 0 imagenumber imageNumber�� 0 
worknumber 
workNumber�� 0 newline newLine�� 0 write_to_file  �� �� �*��/ �jv�&E�O�j E�O �k�kh ��&E�O O��/� B��/�&*�k/��/FO*�k/j O*�,��/a ,j  *�,�a /a ,�&E�Y hY hW JX  a �&E�O_ kE` O)_ _ %a _ %a %_ %a %_ %a %��/%_ %em+  O��%�&E�[OY�TUUO�` �������z{���� *0 getsubtypeauthority getSubtypeAuthority�� ��|�� |  ���� 0 subtypelist subtypeList��  z ������������ 0 subtypelist subtypeList�� 0 authoritylist authorityList�� 0 subtypecount subtypeCount�� 0 i  �� 0 	authority  { !����������������� ������1����;����C������ef��g��h����
�� 
cDB �� 0 irissubtype irisSubtype
�� 
list
�� .corecnte****       ****
�� 
ctxt
�� 
cobj
�� 
cRQT
�� 
ccel
�� 
cwin
�� .FMPRFINDnull���    obj 
�� 
pCRW
�� 
vlue
�� .coredoexbool        obj ��  ��  �� 0 
errorcount 
errorCount�� "0 outputdirectory outputDirectory�� 0 errorlog errorLog�� 0 imagenumber imageNumber�� 0 
worknumber 
workNumber�� 0 newline newLine�� 0 write_to_file  �� �� �*��/ �jv�&E�O�j E�O �k�kh ��&E�O O��/� B��/�&*�k/��/FO*�k/j O*�,��/a ,j  *�,�a /a ,�&E�Y hY hW JX  a �&E�O_ kE` O)_ _ %a _ %a %_ %a %_ %a %��/%_ %em+  O��%�&E�[OY�TUUO�a �������}~���� 
0 joinby  �� ����   ������ 0 somestrings  �� 	0 delim  ��  } ���������� 0 somestrings  �� 	0 delim  �� 0 olddelim oldDelim�� 
0 retval  ~ ����������
�� 
ascr
�� 
txdl
�� 
TEXT��  ��  �� + ��,E�O���,FO��&E�O���,FW X  ���,FO�b ������������� 0 listtrim listTrim�� ����� �  ���� 0 lstvalue lstValue��  � ������������ 0 lstvalue lstValue�� 0 newlist newList�� 0 numitems numItems�� 0 i  �� 0 tempitem tempItem� ����������
�� 
list
�� .corecnte****       ****
�� 
cobj
�� 
ctxt�� 0 	righttrim 	rightTrim�� 7jv�&E�O�j E�O #k�kh ��/�&E�O�)�k+ %�&E�[OY��O�c ������������� 0 	read_file  �� ����� �  ���� 0 the_file  ��  � ���������� 0 the_file  �� 0 file_contents  �� 0 
input_file  �� 0 	file_size  � �������������������������������
�� 
TEXT
�� 
ctxt
�� 
file
�� .rdwropenshor       file
�� .rdwrgeofcomp       ****
�� 
deli
�� 
ret 
�� 
as  
�� 
rdfm
�� 
rdto�� 
�� .rdwrread****        ****
�� .rdwrclosnull���     ****��  ��  �� T��&E�O��&E�O -*�/j E�O�j E�O������k�� E�O�j W X   
�j W X  hO�d ��-���������� 0 	righttrim 	rightTrim�� ����� �  ���� 0 strvalue strValue��  � ����~�}�|�� 0 strvalue strValue� 0 strindex strIndex�~ 0 lastchar lastChar�}  0 carriagereturn carriageReturn�| 0 	spacechar 	spaceChar� �{�z�y�x�w�v�u�t}���{ 
�z .sysontocTEXT       shor
�y 
ctxt�x  
�w 
leng
�v 
cha �u 0 newline newLine
�t 
bool�� ��j �&E�O�j �&E�O��,E�O�j  �Y a��/E�O >h�� 
 �� �&
 �� �&�j 
�kE�Y hO�j ��/E�Y �E�[OY��O�� �[�\[Zk\Z�2EY �e �s��r�q���p�s $0 sendemailmessage sendEmailMessage�r �o��o �  �n�m�l�k�n 0 fromaddress fromAddress�m 0 toaddresslist toAddressList�l 0 messagefile messageFile�k (0 attachmentfilelist attachmentFileList�q  � 	�j�i�h�g�f�e�d�c�b�j 0 fromaddress fromAddress�i 0 toaddresslist toAddressList�h 0 messagefile messageFile�g (0 attachmentfilelist attachmentFileList�f 0 sendmail  �e 0 message  �d 0 i  �c 0 commandline commandLine�b 0 
targetfile 
targetFile� 2���a�`�_�^��] �\./�[�a 
0 joinby  �` 0 newline newLine
�_ 
ctxt�^ 0 	read_file  
�] .corecnte****       ****
�\ 
cobj
�[ .sysoexecTEXT���     TEXT�p �� }�)��l+ %�%�&E�O)�k+ �&E�O��%�%�%�&E�O�j j 9��%�%�%�&E�O 'k�j kh ��/E�O�)�k+ %�%�&E�[OY��Y hO�%�%�%�&E�O�j Uf �Z;�Y�X���W�Z ,0 sendemailmessage_old sendEmailMessage_old�Y �V��V �  �U�T�S�R�U 0 fromaddress fromAddress�T 0 toaddresslist toAddressList�S 0 messagefile messageFile�R (0 attachmentfilelist attachmentFileList�X  � 	�Q�P�O�N�M�L�K�J�I�Q 0 fromaddress fromAddress�P 0 toaddresslist toAddressList�O 0 messagefile messageFile�N (0 attachmentfilelist attachmentFileList�M 0 messagebody messageBody�L 0 
newmessage 
newMessage�K 0 i  �J 0 emailaddress emailAddress�I 0 
targetfile 
targetFile� ��H�G�Fi�E��D�C�B�A��@�?�>�=�<�;�:�9�8�7�6�5�4�3�2�1��0�H 0 	read_file  
�G 
ctxt�F 0 newline newLine
�E .corecnte****       ****
�D 
kocl
�C 
bcke
�B 
prdt
�A 
subj
�@ 
ctnt
�? 
sndr�> �= 
�< .corecrel****      � null
�; 
cobj
�: 
trcp
�9 
insh
�8 
radd
�7 
atts
�6 
atfn
�5 
cpar
�4 
insl
�3 .emsgsendnull���     mssg�2  �1  
�0 .sysodlogaskr        TEXT�W �� �)�k+ �&E�O��%�%�%�%�&E�O�j j ��%�%�%�&E�Y hO*���������� E�O 9k�j kh �a �/E�O� *�a a *a -5�a �l� U[OY��O� B ?k�j kh �a �/E�O*�, *�a �a �la *a i/a 4� U[OY��UO 
�j W X  a j Ug �/��.�-���,�/ 0 splitstring  �. �+��+ �  �*�)�* 0 
somestring  �) 	0 delim  �-  � �(�'�&�%�( 0 
somestring  �' 	0 delim  �& 0 olddelim oldDelim�% 0 retvals  � �$�#�"�!� 
�$ 
ascr
�# 
txdl
�" 
citm�!  �   �, + ��,E�O���,FO��-E�O���,FW X  ���,FO�h �#������ (0 updateprojectonweb updateProjectOnWeb� ��� �  ������ 0 projname projName� 0 stepnum stepNum� 0 	starttime 	startTime� 0 
finishtime 
finishTime� 0 
errorcount 
errorCount�  � �������� 0 projname projName� 0 stepnum stepNum� 0 	starttime 	startTime� 0 
finishtime 
finishTime� 0 
errorcount 
errorCount� 0 urltext urlText� 0 i  � �@��U]fnw����
�	� .0 imageprojectstatusurl imageProjectStatusURL
� 
ctxt
� 
bool
� .GURLGURLnull��� ��� TEXT�
 

�	 .aevtquitnull���    obj � x��%�%�&E�O�k 
 �l �& ��%�%�&E�Y hO�� ��%�%�&E�Y hO�� ��%�%�&E�Y hO��%�%�&E�O� �j O k�kh hY��O*j Ui �������� 0 write_to_file  � ��� �  ���� 0 the_file  � 0 
the_string  � 0 	appending  �  � � �������  0 the_file  �� 0 
the_string  �� 0 	appending  �� 0 
write_file  � ��������������������������������
�� 
TEXT
�� 
file
�� 
perm
�� .rdwropenshor       file
�� 
set2
�� .rdwrseofnull���     ****
�� 
refn
�� 
wrat
�� rdwreof 
�� 
as  
�� 
utf8�� 
�� .rdwrwritnull���     ****
�� .rdwrclosnull���     ****��  ��  � S��&E�O 5*�/�el E�O�f  ��jl Y hO������� O�j W X   
�j W X  hj �����������
�� .aevtoappnull  �   � ****� k    ���  d��  j��  x��  ���  ���  ���  ���  ���  ���  ���  ���  ���  ���  ���  ���  ���  ���  ���  ���  ���  ��� �� 	�� ��� ��� ��� ��� ��� 	�� 	�� 	�� 	W�� 	_�� 	n�� 	�����  ��  ��  � �������������� 0 i  �� 0 linenum lineNum�� 0 	workindex 	workIndex�� 0 wsindex wsIndex�� 0 
imageindex 
imageIndex�� 0 filecnt fileCnt� � i�� s t�� }�� ����� ��� ������� ��� ��� ��� ��� ��� ��� ��� ��� ��� �����������������������������������������������������	@��	h��	{	|	}���������������	�����	���	�
4
5
6
7
8
9
:
;
<
=
>
?
@
A
B
C
D
E
F
G
H
I
J
K��
e��������
�
���
�
���
�
���
�
���������HI�������a���������������������������������������$��������G��S����k��{������������~��}��|��{�z�y!�x+�w�v�u����������t����s�r�q�p>Pbs�o�n�m�l��k�j�i�h�g2�f�e�dDO�cT�bW�a�� 0 irispassword irisPassword�� (0 irisremotelocation irisRemoteLocation�� "0 outputdirectory outputDirectory
�� 
ctxt�� .0 imageprojectstatusurl imageProjectStatusURL�� $0 fromemailaddress fromEmailAddress�� 40 getemaildistributionlist getEmailDistributionList
�� 
list�� (0 toemailaddresslist toEmailAddressList�� 0 irissurrogat irisSurrogat�� 0 iriswslinks irisWSLinks�� 0 
irissource 
irisSource�� 0 irisdigital irisDigital�� 0 irissubject irisSubject�� 0 irissubtype irisSubtype�� 40 outputstatisticsfilename outputStatisticsFilename�� "0 inputworknofile inputWorkNoFile�� 0 workserrorlog worksErrorLog�� 0 errorlog errorLog�� 	
�� .sysontocTEXT       shor��  0 fieldseparator fieldSeparator�� ��  0 valueseparator valueSeparator�� 
�� 0 newline newLine�� 0 
errorcount 
errorCount�� (0 exportedimagecount exportedImageCount�� &0 projectimagecount projectImageCount�� 0 projectname projectName
�� .earslvolutxt  P ��� null�� 0 
volumelist 
volumeList�� ,0 dropboxvolumemounted dropboxVolumeMounted
�� .corecnte****       ****
�� 
cobj
�� .aevtmvolnull���     TEXT�� 0 	read_file  �� 0 inputtextfile inputTextFile�� 0 splitstring  �� 0 inputrecords inputRecords��  0 worknumberlist workNumberList�� 0 linedata lineData�� 
0 fields  �� "0 worknumbercount workNumberCount��  0 outputfilename outputFilename
�� 
givu
�� .sysodlogaskr        TEXT��p
�� .misccurdldt    ��� null�� 0 	starttime 	startTime�� &0 getdatetimestring getDateTimeString�� 0 startdatetime startDateTime�� �� (0 updateprojectonweb updateProjectOnWeb�� 0 write_to_file  �� 0 
headerline 
headerLine
�� .GURLGURLnull��� ��� TEXT
�� 
cDB �� 0 irisdigitaldb irisDigitalDB
�� .coredoexbool        obj �� 0 irissourcedb irisSourceDB�� 0 irissubjectdb irisSubjectDB�� 0 irissubtypedb irisSubtypeDB��  0 irissurrogatdb irisSurrogatDB�� 0 
worknumber 
workNumber�� "0 imagenumberlist imageNumberList�� 0 iriswslinksdb irisWSLinksDB
�� 
crow
�� 
ID  �  
�� 
ccel
�� 
vlue�� 0 	imagelist 	imageList�� 0 
imagecount 
imageCount
�� 
long
�� kfrmID  �� 0 wslinkrecord wslinkRecord�� 0 imagenumber imageNumber��  ��  �� 0 imgnum imgNum
�� 
cRQT
�� 
cwin
�� .FMPRFINDnull���    obj 
�� 
pCRW�� 0 	righttrim 	rightTrim�� 0 	imagetype 	imageType�� 0 imageapproved imageApproved��  0 getdigitalfile getDigitalFile�� 0 digitalmedia digitalMedia�� ,0 imagedigitalfilename imageDigitalFilename�� 0 
imagecolor 
imageColor�� 0 imageviewtype imageViewType�� 0 listtrim listTrim�� ,0 imageviewdescription imageViewDescription�� 0 imageviewdate imageViewDate�� 0 imagesubjects imageSubjects�� *0 getsubjectauthority getSubjectAuthority�� .0 imagesubjectauthority imageSubjectAuthority� ,0 imagesubjectsubtypes imageSubjectSubtypes�~ .0 imagesubtypeauthority imageSubtypeAuthority�} 0 imagepid imagePID�| &0 imagesourcenumber imageSourceNumber�{ "0 imagevendorcode imageVendorCode�z *0 imageidentifiertype imageIdentifierType�y .0 imageidentifiernumber imageIdentifierNumber�x $0 imageprojectname imageProjectName�w "0 imageexportdate imageExportDate�v 
0 joinby  �u *0 imagemetadatastring imageMetadataString
�t 
bool�s ,0 getsourceinformation getSourceInformation�r ,0 sourcemetadatastring sourceMetadataString�q 0 metadataline metadataLine�p 0 endtime endTime�o ,0 emailfileattachments emailFileAttachments�n 0 workerrorfile workErrorFile�m 0 workerrorlist workErrorList�l  0 workerrorcount workErrorCount�k 0 	errorfile 	errorFile
�j 
alis�i 0 emailbodyfile emailBodyFile�h �g $0 sendemailmessage sendEmailMessage
�f .coredeloobj        obj �e 0 workfile workFile�d 0 enddatetime endDateTime
�c 
btns
�b 
dflt�a ����E�O��%�%E�O�E�O��&E�O��&E�O)�k+ �&E�Oa E` Oa E` Oa E` Oa E` Oa E` Oa E` Oa E` Oa E` Oa  E` !Oa "E` #Oa $j %�&E` &Oa 'j %�&E` (Oa )j %�&E` *OjE` +OjE` ,OjE` -Oa .E` /O*j 0E` 1OfE` 2O ,k_ 1j 3kh  _ 1a 4�/a 5  
eE` 2Y h[OY��O_ 2 a 6j 7Y hO)�_ %k+ 8�&E` 9O)_ 9_ *l+ :�&E` ;Ojv�&E` <O il_ ;j 3kh _ ;a 4�/�&E` =O*_ =_ &l+ :�&E` >O_ >a 4k/a ? &_ <_ >a 4k/%�&E` <O_ >a 4l/�&E` /Y h[OY��O_ <j 3E` @O_ /a A%�&E` BOa C_ @%a D%_ /%a E%a Fjl GOa Hna IB*j JE` KO)_ Kk+ L�&E` MO)_ /l_ Ma Nja O+ PO)�_ %a Q_ *%em+ RO)�_ %a S_ K%_ *%em+ ROa T_ &%a U%_ &%a V%_ &%a W%_ &%a X%_ &%a Y%_ &%a Z%_ &%a [%_ &%a \%_ &%a ]%_ &%a ^%_ &%a _%_ &%a `%_ &%a a%_ &%a b%_ &%a c%_ &%a d%_ &%a e%_ &%a f%_ &%a g%_ &%a h%_ &%a i%_ &%a j%_ &%a k%_ *%�&E` lO)�_ B%_ lfm+ RO)�_ #%a mfm+ RO�_ %j nO*a o_ /E` pO_ pj qf  a r_ %a s%j GOhY hO�_ %j nO*a o_ /E` tO_ tj qf  a u_ %a v%j GOhY hO�_ %j nO*a o_ /E` wO_ wj qf  a x_ %a y%j GOhY hO�_ %j nO*a o_ /E` zO_ zj qf  a {_ %a |%j GOhY hO�_ %j nO*a o_ /E` }O_ }j qf  a ~_ %a %j GOhY hOxk_ @kh _ <a 4�/E` �Ojv�&E` �O�_ %j nO*a o_ /E` �O_ �j qf  a �_ %a �%j GOhY hO*a o_ / �*a �-a �,a �[a �a �/a �,\Z_ �81�&E` �O_ �j 3E` �O_ �j �jv�&E` �O yk_ �kh  ?*a �_ �a 4�/a �&a �0E` �O_ �a �a �/a �,E` �O_ �_ �%�&E` �W +X � �_ +kE` +O)�_ #%a �_ �%a �%_ *%em+ R[OY��Y )�_ %a �_ �%a �%_ *%em+ RUO_ �j 3E` �O_ �j*a o_ /k_ �kh _ �a 4�/E` �O_ �*a �k/a �a �/FO*a �k/j �O*a �,a �a �/a �,_ � �*a �,a �a �/a �,E` �O)*a �,a �a �/a �,k+ �E` �O)*a �,a �a �/a �,k+ �E` �O)_ �k+ ��&E` �O_ �a 4k/�&E` �O)*a �,a �a �/a �,k+ ��&E` �O*a �,a �a �/a �,�&E` �O)_ �k+ �E` �O)*a �,a �a �/a �,k+ ��&E` �O)*a �,a �a �/a �,k+ ��&E` �O*a �,a �a �/a �,�&E` �O)_ �k+ �E` �O)_ �k+ ��&E` �O)_ �k+ �E` �O*a �,a �a �/a �,�&E` �O)_ �k+ �E` �O)_ �k+ ��&E` �O)_ �k+ �E` �O)*a �,a �a �/a �,k+ ��&E` �O*a �,a �a �/a �,E` �O)*a �,a �a �/a �,k+ ��&E` �O)*a �,a �a �/a �,k+ ��&E` �O)*a �,a �a �/a �,k+ ��&E` �O)*a �,a �a �/a �,k+ ��&E` �O*a �,a �a �/a �,E` �O_ �_ &%_ �%_ &%_ �%_ &%_ �%_ &%_ �%_ &%)_ �_ (l+ �%_ &%_ �%_ &%_ �%_ &%)_ �_ (l+ �%_ &%)_ �_ (l+ �%_ &%)_ �_ (l+ �%_ &%)_ �_ (l+ �%_ &%_ �%_ &%_ �%_ &%_ �%_ &%_ �%_ &%_ �%�&E` �Y Ga ��&E` �Oa ��&E` �Oa ��&E` �Oa ��&E` �Oa ��&E` �Oa ��&E` �Oa ��&E` �O_ �a �	 _ �a �a �& �_ �a � 
 _ �a � a �& x_ �a � j)_ �k+ ��&E` �O_ �_ &%_ /%_ &%_ �%_ &%_ �%_ *%�&E` �O)�_ B%_ �em+ RO_ ,kE` ,O_ �_ /  _ -kE` -Y hY hY hY h[OY��UY h[OY��O*j JE` �O)�_ %a �_ ,%_ *%em+ RO)�_ %a �_ -%_ *%em+ RO)�_ %a �_ +%_ *%em+ RO)�_ %a �_ �%_ *%em+ RUOjv�&E` �O)�_ !%k+ 8�&E` �O)_ �_ *l+ :�&E` �OjE` �O 0k_ �j 3kh  _ �a 4�/a � _ �kE` �Y h[OY��O_ �j #�_ !%�&E` �O_ �*a �_ �/%�&E` �Y hO_ +j #�_ #%�&E` �O_ �*a �_ �/%�&E` �Y hO�_ %�&E` �O*��_ �_ �a �+ �Oa � W_ �j �O  k_ �j 3kh _ �a 4�/j �[OY��O_ �j 	 _ +j a �& �_ %�&E` �O_ �j �Y hUO)_ �k+ L�&E` �O)_ /la �_ �_ +a O+ POa I a �a �a �kva �a �a Fja � GUo ascr  ��ޭ