FasdUAS 1.101.10   ��   ��    k             l     �� ��    J D License and Copyright: The contents of this file are subject to the       	  l     �� 
��   
 O I Educational Community License (the "License"); you may not use this file    	     l     �� ��    R L except in compliance with the License. You may obtain a copy of the License         l     �� ��    5 / at http://www.opensource.org/licenses/ecl1.txt         l     ������  ��        l     �� ��    Q K Software distributed under the License is distributed on an "AS IS" basis,         l     �� ��    S M WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for         l     �� ��    T N the specific language governing rights and limitations under the License.</p>         l     ������  ��        l     ��  ��     M G The entire file consists of original code.  Copyright (c) 2002-2005 by      ! " ! l     �� #��   # = 7 The Rector and Visitors of the University of Virginia.    "  $ % $ l     �� &��   &   All rights reserved.    %  ' ( ' l     ������  ��   (  ) * ) l     �� +��   + !  Script: iris2tabbed13step3    *  , - , l     �� .��   . � � Description: This script updates IRIS work and image export dates. This script reads the exported project files to identify the work and image  records to update.    -  / 0 / l     ������  ��   0  1 2 1 l     �� 3��   3 a [ NOTE: Make sure to set the irisPassword field to a valid value that allows for logging in.    2  4 5 4 l     ������  ��   5  6 7 6 l     �� 8��   8 / ) Author: Jack Kelly  <jlk4p@virginia.edu>    7  9 : 9 l     ������  ��   :  ; < ; l     �� =��   = q k 2006/08/01 - (jlk4p) Updated the archiveDirectory to reflect the new directory structure for sharing data.    <  > ? > l     �� @��   @ j d 2006/12/06 - (jlk4p) Updated in an attempt to make sure that the script updates the MySQL database.    ?  A B A l     �� C��   C c ] 2007/01/24 - (jlk4p) Updated to modify the email distribution list to exclude ul-dlpsscripts    B  D E D l     �� F��   F s m 2007/01/26 - (jlk4p) Updated to move email distribution list to an external file that is read by the script.    E  G H G l     �� I��   I c ] 2008/01/15 - (jlk4p) Updated sendEmailMessage routine to use Unix command-line mail feature.    H  J K J l     ������  ��   K  L M L l     N�� N r      O P O m      Q Q  master    P o      ���� 0 irispassword irisPassword��   M  R S R l     �� T��   T 8 2set irisDirectory to "Main:Users:jlk4p:data:IRIS:"    S  U V U l    W�� W r     X Y X b    	 Z [ Z b     \ ] \ m     ^ ^  FMP5://    ] o    ���� 0 irispassword irisPassword [ m     _ _  @udon.lib.virginia.edu/    Y o      ���� (0 irisremotelocation irisRemoteLocation��   V  ` a ` l     �� b��   b X Rset archiveDirectory to "Main:shares:dropbox:inbox:finearts:iris_exports:archive:"    a  c d c l    e�� e r     f g f m     h h ? 9Main:Volumes:DROPBOX:inbox:finearts:iris_exports:archive:    g o      ���� $0 archivedirectory archiveDirectory��   d  i j i l     �� k��   k � {set imageProjectStatusURL to "http://localhost/~jlk4p/dlps/applescripts_status/updateImageProjectExportStatus.php?" as text    j  l m l l    n�� n r     o p o c     q r q m     s s i chttp://alioth.lib.virginia.edu/dlps/uva-only/applescript_status/updateImageProjectExportStatus.php?    r m    ��
�� 
ctxt p o      ���� .0 imageprojectstatusurl imageProjectStatusURL��   m  t u t l    v�� v r     w x w c     y z y m     { {  jlk4p@virginia.edu    z m    ��
�� 
ctxt x o      ���� $0 fromemailaddress fromEmailAddress��   u  | } | l   & ~�� ~ r    &  �  c    $ � � � n   " � � � I    "�� ����� 40 getemaildistributionlist getEmailDistributionList �  ��� � m     � �  email_distribution.config   ��  ��   �  f     � m   " #��
�� 
list � o      ���� (0 toemailaddresslist toEmailAddressList��   }  � � � l     ������  ��   �  � � � l  ' . ��� � r   ' . � � � m   ' * � �  	WORKS.fp5    � o      ���� 0 	irisworks 	irisWorks��   �  � � � l  / 6 ��� � r   / 6 � � � m   / 2 � �  SURROGAT.fp5    � o      ���� 0 irissurrogat irisSurrogat��   �  � � � l  7 D � � � r   7 D � � � c   7 @ � � � l  7 > ��� � I  7 >�� ���
�� .sysontocTEXT       shor � m   7 :���� 	��  ��   � m   > ?��
�� 
ctxt � o      ����  0 fieldseparator fieldSeparator �   tab character    �  � � � l  E R � � � r   E R � � � c   E N � � � l  E L ��� � I  E L�� ���
�� .sysontocTEXT       shor � m   E H���� ��  ��   � m   L M��
�� 
ctxt � o      ����  0 valueseparator valueSeparator � %  ascii unit separator character    �  � � � l  S ` ��� � r   S ` � � � c   S \ � � � l  S Z ��� � I  S Z�� ���
�� .sysontocTEXT       shor � m   S V���� 
��  ��   � m   Z [��
�� 
ctxt � o      ���� 0 newline newLine��   �  � � � l  a j ��� � r   a j � � � c   a f � � � m   a d � �       � m   d e��
�� 
ctxt � o      ���� 0 	outputlog 	outputLog��   �  � � � l  k t ��� � r   k t � � � c   k p � � � m   k n � �       � m   n o��
�� 
ctxt � o      ���� 0 errorlog errorLog��   �  � � � l  u z ��� � r   u z � � � m   u v����   � o      ���� 0 
errorcount 
errorCount��   �  � � � l  { � ��� � r   { � � � � m   { |����   � o      ���� 0 	workcount 	workCount��   �  � � � l  � � ��� � r   � � � � � m   � �����   � o      ���� $0 updatedworkcount updatedWorkCount��   �  � � � l  � � ��� � r   � � � � � m   � �����   � o      ���� 0 
imagecount 
imageCount��   �  � � � l  � � ��� � r   � � � � � m   � �����   � o      ���� &0 updatedimagecount updatedImageCount��   �  � � � l     ������  ��   �  � � � l     �� ���   � K E getDateTimeString returns a string of the format YYYY-MM-DD HH:MM:SS    �  � � � i      � � � I      �� ����� &0 getdatetimestring getDateTimeString �  ��� � o      ���� 0 
dateobject 
dateObject��  ��   � k    � � �  � � � q       � � �� ��� 0 d   � �� ��� 0 daystr dayStr � �� ��� 0 m   � �� ��� 0 monstr monStr � �� ��� 0 y   � �� ��� 0 secs   � �� ��� 0 hrstr hrStr � �� ��� 0 min   � �� ��� 0 minstr minStr � �� ��� 0 secstr secStr � ������  0 datetimestring dateTimeString��   �  � � � r      � � � n      � � � 1    ��
�� 
day  � o     ���� 0 
dateobject 
dateObject � o      ���� 0 d   �  � � � Z     � ��� � � l   	 ��  A    	 o    ���� 0 d   m    ���� 
��   � r     c     b     m    		  0    o    �� 0 d   m    �~
�~ 
ctxt o      �}�} 0 daystr dayStr��   � r    

 c     o    �|�| 0 d   m    �{
�{ 
ctxt o      �z�z 0 daystr dayStr �  r    ! n     m    �y
�y 
mnth o    �x�x 0 
dateobject 
dateObject o      �w�w 0 m    Z   " ��v l  " %�u =   " % o   " #�t�t 0 m   m   # $�s
�s 
jan �u   r   ( + m   ( )  01    o      �r�r 0 monstr monStr   l  . 1!�q! =   . 1"#" o   . /�p�p 0 m  # m   / 0�o
�o 
feb �q    $%$ r   4 7&'& m   4 5((  02   ' o      �n�n 0 monstr monStr% )*) l  : =+�m+ =   : =,-, o   : ;�l�l 0 m  - m   ; <�k
�k 
mar �m  * ./. r   @ C010 m   @ A22  03   1 o      �j�j 0 monstr monStr/ 343 l  F I5�i5 =   F I676 o   F G�h�h 0 m  7 m   G H�g
�g 
apr �i  4 898 r   L O:;: m   L M<<  04   ; o      �f�f 0 monstr monStr9 =>= l  R U?�e? =   R U@A@ o   R S�d�d 0 m  A m   S T�c
�c 
may �e  > BCB r   X [DED m   X YFF  05   E o      �b�b 0 monstr monStrC GHG l  ^ aI�aI =   ^ aJKJ o   ^ _�`�` 0 m  K m   _ `�_
�_ 
jun �a  H LML r   d iNON m   d gPP  06   O o      �^�^ 0 monstr monStrM QRQ l  l qS�]S =   l qTUT o   l m�\�\ 0 m  U m   m p�[
�[ 
jul �]  R VWV r   t yXYX m   t wZZ  07   Y o      �Z�Z 0 monstr monStrW [\[ l  | �]�Y] =   | �^_^ o   | }�X�X 0 m  _ m   } ��W
�W 
aug �Y  \ `a` r   � �bcb m   � �dd  08   c o      �V�V 0 monstr monStra efe l  � �g�Ug =   � �hih o   � ��T�T 0 m  i m   � ��S
�S 
sep �U  f jkj r   � �lml m   � �nn  09   m o      �R�R 0 monstr monStrk opo l  � �q�Qq =   � �rsr o   � ��P�P 0 m  s m   � ��O
�O 
oct �Q  p tut r   � �vwv m   � �xx  10   w o      �N�N 0 monstr monStru yzy l  � �{�M{ =   � �|}| o   � ��L�L 0 m  } m   � ��K
�K 
nov �M  z ~~ r   � ���� m   � ���  11   � o      �J�J 0 monstr monStr ��� l  � ���I� =   � ���� o   � ��H�H 0 m  � m   � ��G
�G 
dec �I  � ��F� r   � ���� m   � ���  12   � o      �E�E 0 monstr monStr�F  �v   ��� r   � ���� n   � ���� 1   � ��D
�D 
year� o   � ��C�C 0 
dateobject 
dateObject� o      �B�B 0 y  � ��� r   � ���� n   � ���� 1   � ��A
�A 
time� o   � ��@�@ 0 
dateobject 
dateObject� o      �?�? 0 secs  � ��� Z   ����>�� l  � ���=� @   � ���� o   � ��<�< 0 secs  � m   � ��;�;�=  � k   ��� ��� r   � ���� _   � ���� o   � ��:�: 0 secs  � m   � ��9�9� o      �8�8 0 h  � ��� r   � ���� `   � ���� o   � ��7�7 0 secs  � m   � ��6�6� o      �5�5 0 secs  � ��4� Z   ����3�� l  � ���2� A   � ���� o   � ��1�1 0 h  � m   � ��0�0 
�2  � r   ���� c   ���� b   ���� m   � ���  0   � o   � �/�/ 0 h  � m  �.
�. 
ctxt� o      �-�- 0 hrstr hrStr�3  � r  ��� c  ��� o  	�,�, 0 h  � m  	
�+
�+ 
ctxt� o      �*�* 0 hrstr hrStr�4  �>  � r  ��� m  ��  00   � o      �)�) 0 hrstr hrStr� ��� Z  M���(�� l ��'� @  ��� o  �&�& 0 secs  � m  �%�% <�'  � k  E�� ��� r  %��� _  #��� o  �$�$ 0 secs  � m  "�#�# <� o      �"�" 0 min  � ��� r  &-��� `  &+��� o  &'�!�! 0 secs  � m  '*� �  <� o      �� 0 secs  � ��� Z  .E����� l .1��� A  .1��� o  ./�� 0 min  � m  /0�� 
�  � r  4=��� c  4;��� b  49��� m  47��  0   � o  78�� 0 min  � m  9:�
� 
ctxt� o      �� 0 minstr minStr�  � r  @E��� c  @C��� o  @A�� 0 min  � m  AB�
� 
ctxt� o      �� 0 minstr minStr�  �(  � r  HM��� m  HK��  00   � o      �� 0 minstr minStr� ��� Z  Ne����� l NQ��� A  NQ��� o  NO�� 0 secs  � m  OP�� 
�  � r  T]��� c  T[��� b  TY��� m  TW��  0   � o  WX�� 0 secs  � m  YZ�
� 
ctxt� o      �� 0 secstr secStr�  � r  `e��� c  `c��� o  `a�� 0 secs  � m  ab�

�
 
ctxt� o      �	�	 0 secstr secStr� ��� r  f�   c  f� b  f� b  f� b  f	 b  f}

 b  fy b  fw b  fs b  fq b  fm b  fk o  fg�� 0 y   m  gj  -    o  kl�� 0 monstr monStr m  mp  -    o  qr�� 0 daystr dayStr m  sv       o  wx�� 0 hrstr hrStr m  y|  :   	 o  }~�� 0 minstr minStr m  �  :    o  ���� 0 secstr secStr m  ���
� 
ctxt o      � �   0 datetimestring dateTimeString�   �  l     ������  ��     l     ��!��  ! | v Retrieves the email distribution list from a text file stored in the same location as the AppleScript being executed.     "#" i    $%$ I      ��&���� 40 getemaildistributionlist getEmailDistributionList& '��' o      ����  0 configfilename configFileName��  ��  % k     `(( )*) q      ++ ��,�� 0 pathtoscript pathToScript, ��-�� 0 pathlist pathList- ��.�� 0 	pathcount 	pathCount. ��/�� "0 emailconfigfile emailConfigFile/ ��0�� 0 i  0 ��1�� (0 emailaddressstring emailAddressString1 ������ 0 	emaillist 	emailList��  * 232 r     	454 I    ��67
�� .earsffdralis        afdr6  f     7 ��8��
�� 
rtyp8 m    ��
�� 
ctxt��  5 o      ���� 0 pathtoscript pathToScript3 9:9 r   
 ;<; c   
 =>= n  
 ?@? I    ��A���� 0 splitstring  A BCB o    ���� 0 pathtoscript pathToScriptC D��D m    EE  :   ��  ��  @  f   
 > m    ��
�� 
list< o      ���� 0 pathlist pathList: FGF r    HIH I   ��J��
�� .corecnte****       ****J o    ���� 0 pathlist pathList��  I o      ���� 0 	pathcount 	pathCountG KLK r    #MNM c    !OPO m    QQ      P m     ��
�� 
ctxtN o      ���� "0 emailconfigfile emailConfigFileL RSR Y   $ AT��UV��T r   0 <WXW c   0 :YZY b   0 8[\[ b   0 6]^] o   0 1���� "0 emailconfigfile emailConfigFile^ l  1 5_��_ n   1 5`a` 4   2 5��b
�� 
cobjb o   3 4���� 0 i  a o   1 2���� 0 pathlist pathList��  \ m   6 7cc  :   Z m   8 9��
�� 
ctxtX o      ���� "0 emailconfigfile emailConfigFile�� 0 i  U m   ' (���� V l  ( +d��d \   ( +efe o   ( )���� 0 	pathcount 	pathCountf m   ) *���� ��  ��  S ghg r   B Iiji c   B Gklk b   B Emnm o   B C���� "0 emailconfigfile emailConfigFilen o   C D����  0 configfilename configFileNamel m   E F��
�� 
ctxtj o      ���� "0 emailconfigfile emailConfigFileh opo r   J Tqrq c   J Rsts n  J Puvu I   K P��w���� 0 	read_file  w x��x o   K L���� "0 emailconfigfile emailConfigFile��  ��  v  f   J Kt m   P Q��
�� 
ctxtr o      ���� (0 emailaddressstring emailAddressStringp y��y r   U `z{z c   U ^|}| n  U \~~ I   V \������� 0 splitstring  � ��� o   V W���� (0 emailaddressstring emailAddressString� ���� m   W X��  ,   ��  ��    f   U V} m   \ ]��
�� 
list{ o      ���� 0 	emaillist 	emailList��  # ��� l     ������  ��  � ��� l     �����  �   joinby   � ��� i    ��� I      ������� 
0 joinby  � ��� o      ���� 0 somestrings  � ���� o      ���� 	0 delim  ��  ��  � k     *�� ��� l     �����  � ) # join list of strings by delim char   � ��� Q     '���� k    �� ��� r    ��� n   ��� 1    ��
�� 
txdl� 1    ��
�� 
ascr� o      ���� 0 olddelim oldDelim� ��� r   	 ��� o   	 
���� 	0 delim  � n     ��� 1    ��
�� 
txdl� 1   
 ��
�� 
ascr� ��� r    ��� c    ��� o    ���� 0 somestrings  � m    ��
�� 
TEXT� o      ���� 
0 retval  � ���� r    ��� o    ���� 0 olddelim oldDelim� n     ��� 1    ��
�� 
txdl� 1    ��
�� 
ascr��  � R      ������
�� .ascrerr ****      � ****��  ��  � r   " '��� o   " #���� 0 olddelim oldDelim� n     ��� 1   $ &��
�� 
txdl� 1   # $��
�� 
ascr� ���� L   ( *�� o   ( )���� 
0 retval  ��  � ��� l     ������  ��  � ��� l     �����  � !  reads a file into a string   � ��� i    ��� I      ������� 0 	read_file  � ���� o      ���� 0 the_file  ��  ��  � k     S�� ��� r     ��� c     ��� o     ���� 0 the_file  � m    ��
�� 
TEXT� o      ���� 0 the_file  � ��� r    ��� c    	��� m    ��      � m    ��
�� 
ctxt� o      ���� 0 file_contents  � ��� Q    P���� k    7�� ��� r    ��� I   �����
�� .rdwropenshor       file� 4    ���
�� 
file� o    ���� 0 the_file  ��  � o      ���� 0 
input_file  � ��� r    !��� l   ���� I   �����
�� .rdwrgeofcomp       ****� o    ���� 0 
input_file  ��  ��  � o      ���� 0 	file_size  � ��� r   " 1��� l  " /���� I  " /����
�� .rdwrread****        ****� o   " #���� 0 
input_file  � ����
�� 
deli� o   $ %��
�� 
ret � ����
�� 
as  � m   & '��
�� 
ctxt� ����
�� 
rdfm� m   ( )���� � �����
�� 
rdto� o   * +���� 0 	file_size  ��  ��  � o      ���� 0 file_contents  � ���� I  2 7���~
� .rdwrclosnull���     ****� o   2 3�}�} 0 
input_file  �~  ��  � R      �|�{�z
�| .ascrerr ****      � ****�{  �z  � Q   ? P���y� I  B G�x��w
�x .rdwrclosnull���     ****� o   B C�v�v 0 
input_file  �w  � R      �u�t�s
�u .ascrerr ****      � ****�t  �s  �y  � ��r� L   Q S�� o   Q R�q�q 0 file_contents  �r  � ��� l     �p�o�p  �o  � ��� l     �n��n  � � � sends an email message using Unix mail command therefore it uses the user logged in as the from address. So the first parameter   � ��� l     �m �m    #  to this function is ignored.   �  i     I      �l�k�l $0 sendemailmessage sendEmailMessage  o      �j�j 0 fromaddress fromAddress 	 o      �i�i 0 toaddresslist toAddressList	 
�h
 o      �g�g 0 messagebody messageBody�h  �k   k     ,  p       �f�e�f 0 newline newLine�e    q       �d�d 0 sendmail   �c�c 0 message   �b�b 0 i   �a�`�a 0 commandline commandLine�`   �_ O     , k    +  r     c     b      b    !"! m    ## / )mail -s "IRIS project exprt date update"    " n   $%$ I    �^&�]�^ 
0 joinby  & '(' o    �\�\ 0 toaddresslist toAddressList( )�[) m    **  ,   �[  �]  %  f      o    �Z�Z 0 newline newLine m    �Y
�Y 
ctxt o      �X�X 0 sendmail   +,+ r    -.- c    /0/ o    �W�W 0 messagebody messageBody0 m    �V
�V 
ctxt. o      �U�U 0 message  , 121 l   �T�S�T  �S  2 343 r    %565 c    #787 b    !9:9 b    ;<; b    =>= m    ??  echo '   > o    �R�R 0 message  < m    @@ 
 ' |    : o     �Q�Q 0 sendmail  8 m   ! "�P
�P 
ctxt6 o      �O�O 0 commandline commandLine4 A�NA I  & +�MB�L
�M .sysoexecTEXT���     TEXTB o   & '�K�K 0 commandline commandLine�L  �N   m     CC�null     ߀�� 1�
Finder.appd in as the from address. So the first parameter?" asMACS   alis    Z  Main                       ��#H+   1�
Finder.app                                                      5�g~5        ����  	                CoreServices    � #c      �gą     1� * (  +Main:System:Library:CoreServices:Finder.app    
 F i n d e r . a p p  
  M a i n  &System/Library/CoreServices/Finder.app  / ��  �_   DED l     �J�I�J  �I  E FGF l     �HH�H  H   sends an email message   G IJI i    KLK I      �GM�F�G ,0 sendemailmessage_old sendEmailMessage_oldM NON o      �E�E 0 fromaddress fromAddressO PQP o      �D�D 0 toaddresslist toAddressListQ R�CR o      �B�B 0 messagebody messageBody�C  �F  L k     `SS TUT p      VV �A�@�A 0 newline newLine�@  U WXW q      YY �?Z�? 0 messagebody messageBodyZ �>[�> 0 
newmessage 
newMessage[ �=�<�= 0 i  �<  X \�;\ O     `]^] k    ___ `a` l   �:�9�:  �9  a bcb r    ded I   �8�7f
�8 .corecrel****      � null�7  f �6gh
�6 
koclg m    �5
�5 
bckeh �4i�3
�4 
prdti K    jj �2kl
�2 
subjk m   	 
mm % IRIS project export date update   l �1no
�1 
ctntn o    �0�0 0 messagebody messageBodyo �/p�.
�/ 
sndrp o    �-�- 0 fromaddress fromAddress�.  �3  e o      �,�, 0 
newmessage 
newMessagec qrq l   �+s�+  s 0 * Add email addresses to the recipient list   r tut Y    Gv�*wx�)v k   % Byy z{z r   % +|}| l  % )~�(~ n   % )� 4   & )�'�
�' 
cobj� o   ' (�&�& 0 i  � o   % &�%�% 0 toaddresslist toAddressList�(  } o      �$�$ 0 emailaddress emailAddress{ ��#� O  , B��� I  0 A�"�!�
�" .corecrel****      � null�!  � � ��
�  
kocl� m   2 3�
� 
trcp� ���
� 
insh� n   4 8���  :   7 8� 2  4 7�
� 
trcp� ���
� 
prdt� K   9 =�� ���
� 
radd� o   : ;�� 0 emailaddress emailAddress�  �  � o   , -�� 0 
newmessage 
newMessage�#  �* 0 i  w m    �� x l    ��� I    ���
� .corecnte****       ****� o    �� 0 toaddresslist toAddressList�  �  �)  u ��� Q   H _���� I  K P���
� .emsgsendnull���     mssg� o   K L�� 0 
newmessage 
newMessage�  � R      ���
� .ascrerr ****      � ****�  �  � I  X _�
��	
�
 .sysodlogaskr        TEXT� m   X [��  Unable to send email!   �	  �  ^ m     ���null     ߀��   Mail.appppd in as the from address. So th ?�prst paramete��Р��emal   alis    ,  Main                       ��#H+     Mail.app                                                         wS���        ����  	                Applications    � #c      ��2         Main:Applications:Mail.app    M a i l . a p p  
  M a i n  Applications/Mail.app   / ��  �;  J ��� l     ���  �  � ��� l     ���  � &   splitstring - copied from Steve   � ��� i    ��� I      ���� 0 splitstring  � ��� o      �� 0 
somestring  � ��� o      �� 	0 delim  �  �  � k     *�� ��� l     � ��   � "  split string by delim char	   � ��� Q     '���� k    �� ��� r    ��� n   ��� 1    ��
�� 
txdl� 1    ��
�� 
ascr� o      ���� 0 olddelim oldDelim� ��� r   	 ��� o   	 
���� 	0 delim  � n     ��� 1    ��
�� 
txdl� 1   
 ��
�� 
ascr� ��� r    ��� n    ��� 2   ��
�� 
citm� o    ���� 0 
somestring  � o      ���� 0 retvals  � ���� r    ��� o    ���� 0 olddelim oldDelim� n     ��� 1    ��
�� 
txdl� 1    ��
�� 
ascr��  � R      ������
�� .ascrerr ****      � ****��  ��  � r   " '��� o   " #���� 0 olddelim oldDelim� n     ��� 1   $ &��
�� 
txdl� 1   # $��
�� 
ascr� ���� L   ( *�� o   ( )���� 0 retvals  ��  � ��� l     ������  ��  � ��� l     �����  � g a updateProjectOnWeb will pass status information in the URL via Safari that is used to update it.   � ��� i    ��� I      ������� (0 updateprojectonweb updateProjectOnWeb� ��� o      ���� 0 projname projName� ��� o      ���� 0 stepnum stepNum� ��� o      ���� 0 	starttime 	startTime� ��� o      ���� 0 
finishtime 
finishTime� ���� o      ���� 0 
errorcount 
errorCount��  ��  � k     �� ��� p      �� ������ .0 imageprojectstatusurl imageProjectStatusURL��  � ��� q      �� ����� 0 urltext urlText� ������ 0 i  ��  � ��� r     	��� c     ��� b     ��� b     ��� o     ���� .0 imageprojectstatusurl imageProjectStatusURL� m    ��  project=   � o    ���� 0 projname projName� m    ��
�� 
ctxt� o      ���� 0 urltext urlText� ��� Z   
 -������� G   
 ��� G   
 ��� l  
 ���� =   
 ��� o   
 ���� 0 stepnum stepNum� m    ���� ��  � l   ���� =    � � o    ���� 0 stepnum stepNum  m    ���� ��  � l   �� =     o    ���� 0 stepnum stepNum m    ���� ��  � r     ) c     ' b     %	 b     #

 o     !���� 0 urltext urlText m   ! "  &step=   	 o   # $���� 0 stepnum stepNum m   % &��
�� 
ctxt o      ���� 0 urltext urlText��  ��  �  Z   . A���� l  . 1�� >   . 1 o   . /���� 0 	starttime 	startTime m   / 0      ��   r   4 = c   4 ; b   4 9 b   4 7 o   4 5���� 0 urltext urlText m   5 6  	&started=    o   7 8���� 0 	starttime 	startTime m   9 :��
�� 
ctxt o      ���� 0 urltext urlText��  ��    Z   B U !����  l  B E"��" >   B E#$# o   B C���� 0 
finishtime 
finishTime$ m   C D%%      ��  ! r   H Q&'& c   H O()( b   H M*+* b   H K,-, o   H I���� 0 urltext urlText- m   I J..  
&finished=   + o   K L���� 0 
finishtime 
finishTime) m   M N��
�� 
ctxt' o      ���� 0 urltext urlText��  ��   /0/ r   V _121 c   V ]343 b   V [565 b   V Y787 o   V W���� 0 urltext urlText8 m   W X99  &errorCount=   6 o   Y Z���� 0 
errorcount 
errorCount4 m   [ \��
�� 
ctxt2 o      ���� 0 urltext urlText0 :��: O   ` ;<; k   d ~== >?> I  d i��@��
�� .GURLGURLnull��� ��� TEXT@ o   d e���� 0 urltext urlText��  ? ABA Y   j xC��DE��C l  t t��F��  F 4 . give the web browser some time before closing   �� 0 i  D m   m n���� E m   n o���� 
��  B G��G I  y ~������
�� .aevtquitnull���    obj ��  ��  ��  < m   ` aHH�null     ߀��   
Safari.appsed to update it.address. So th���`rst paramete��Р��sfri   alis    4  Main                       ��#H+     
Safari.app                                                       �Z�1k        ����  	                Applications    � #c      �1��         Main:Applications:Safari.app   
 S a f a r i . a p p  
  M a i n  Applications/Safari.app   / ��  ��  � IJI l     ������  ��  J KLK l     ��M��  M F @ updateImageExportDate will update an image record's export date   L NON i     #PQP I      ��R���� .0 updateimageexportdate updateImageExportDateR STS o      ���� 0 imagenum imageNumT U��U o      ���� $0 exportdatestring exportDateString��  ��  Q k     mVV WXW p      YY ��Z�� 0 irissurrogat irisSurrogatZ ��[�� 0 	outputlog 	outputLog[ ��\�� 0 newline newLine\ ��]�� 0 errorlog errorLog] ��^�� 0 
errorcount 
errorCount^ ������ &0 updatedimagecount updatedImageCount��  X _��_ O     m`a` O    lbcb Q    kdefd k    Dgg hih r    jkj o    ���� 0 imagenum imageNumk n      lml 4    ��n
�� 
cceln m    oo  Surrogate No.   m 4    ��p
�� 
cRQTp m    ���� i qrq I    ��s��
�� .FMPRFINDnull���    obj s 4    ��t
�� 
cwint m    ���� ��  r u��u Z   ! Dvw����v l  ! -x��x I  ! -��y��
�� .coredoexbool        obj y l  ! )z��z n   ! ){|{ 1   ' )��
�� 
vlue| n   ! '}~} 4   $ '��
�� 
ccel m   % &��  Surrogate No.   ~ 1   ! $��
�� 
pCRW��  ��  ��  w k   0 @�� ��� r   0 :��� o   0 1���� $0 exportdatestring exportDateString� n      ��� 1   7 9��
�� 
vlue� n   1 7��� 4   4 7���
�� 
ccel� m   5 6��  Export Date   � 1   1 4��
�� 
pCRW� ���� r   ; @��� [   ; >��� o   ; <�� &0 updatedimagecount updatedImageCount� m   < =�~�~ � o      �}�} &0 updatedimagecount updatedImageCount��  ��  ��  ��  e R      �|�{�z
�| .ascrerr ****      � ****�{  �z  f k   L k�� ��� r   L a��� c   L ]��� b   L Y��� b   L U��� b   L S��� o   L O�y�y 0 errorlog errorLog� m   O R�� 8 2ERROR: Unable to set export date for image number    � o   S T�x�x 0 imagenum imageNum� o   U X�w�w 0 newline newLine� m   Y \�v
�v 
ctxt� o      �u�u 0 errorlog errorLog� ��t� r   b k��� [   b g��� o   b e�s�s 0 
errorcount 
errorCount� m   e f�r�r � o      �q�q 0 
errorcount 
errorCount�t  c 4    �p�
�p 
cDB � o    �o�o 0 irissurrogat irisSurrogata m     ���null     ߀�� AFileMaker Pro.app�P         � s. So th >��    cript De��ϐ��FMP5   alis    �  Main                       ��#H+   AFileMaker Pro.app                                               Aں� v & � �����  	                FileMaker Pro 6 Folder    � #c      �L3     A     :Main:Applications:FileMaker Pro 6 Folder:FileMaker Pro.app  $  F i l e M a k e r   P r o . a p p  
  M a i n  5Applications/FileMaker Pro 6 Folder/FileMaker Pro.app   / ��  ��  O ��� l     �n�m�n  �m  � ��� l     �l��l  � C = updateWorkExportDate will update a work record's export date   � ��� i   $ '��� I      �k��j�k ,0 updateworkexportdate updateWorkExportDate� ��� o      �i�i 0 worknum workNum� ��h� o      �g�g $0 exportdatestring exportDateString�h  �j  � k     m�� ��� p      �� �f��f 0 	irisworks 	irisWorks� �e��e 0 	outputlog 	outputLog� �d��d 0 newline newLine� �c��c 0 errorlog errorLog� �b��b 0 
errorcount 
errorCount� �a�`�a $0 updatedworkcount updatedWorkCount�`  � ��_� O     m��� O    l��� Q    k���� k    D�� ��� r    ��� o    �^�^ 0 worknum workNum� n      ��� 4    �]�
�] 
ccel� m    ��  Work No.   � 4    �\�
�\ 
cRQT� m    �[�[ � ��� I    �Z��Y
�Z .FMPRFINDnull���    obj � 4    �X�
�X 
cwin� m    �W�W �Y  � ��V� Z   ! D���U�T� l  ! -��S� I  ! -�R��Q
�R .coredoexbool        obj � l  ! )��P� n   ! )��� 1   ' )�O
�O 
vlue� n   ! '��� 4   $ '�N�
�N 
ccel� m   % &��  Work No.   � 1   ! $�M
�M 
pCRW�P  �Q  �S  � k   0 @�� ��� r   0 :��� o   0 1�L�L $0 exportdatestring exportDateString� n      ��� 1   7 9�K
�K 
vlue� n   1 7��� 4   4 7�J�
�J 
ccel� m   5 6��  Export Date   � 1   1 4�I
�I 
pCRW� ��H� r   ; @��� [   ; >��� o   ; <�G�G $0 updatedworkcount updatedWorkCount� m   < =�F�F � o      �E�E $0 updatedworkcount updatedWorkCount�H  �U  �T  �V  � R      �D�C�B
�D .ascrerr ****      � ****�C  �B  � k   L k�� ��� r   L a��� c   L ]��� b   L Y��� b   L U��� b   L S��� o   L O�A�A 0 errorlog errorLog� m   O R�� 7 1ERROR: Unable to set export date for work number    � o   S T�@�@ 0 worknum workNum� o   U X�?�? 0 newline newLine� m   Y \�>
�> 
ctxt� o      �=�= 0 errorlog errorLog� ��<� r   b k��� [   b g� � o   b e�;�; 0 
errorcount 
errorCount  m   e f�:�: � o      �9�9 0 
errorcount 
errorCount�<  � 4    �8
�8 
cDB  o    �7�7 0 	irisworks 	irisWorks� m     ��_  �  l     �6�5�6  �5    l     �4�4   \ V Copied from http://bbs.applescript.net/viewtopic.php?t=5667&highlight=write+text+file     i   ( +	
	 I      �3�2�3 0 write_to_file    o      �1�1 0 the_file    o      �0�0 0 
the_string   �/ o      �.�. 0 	appending  �/  �2  
 k     R  r      c      o     �-�- 0 the_file   m    �,
�, 
TEXT o      �+�+ 0 the_file   �* Q    R k   	 9  r   	   I  	 �)!"
�) .rdwropenshor       file! 4   	 �(#
�( 
file# o    �'�' 0 the_file  " �&$�%
�& 
perm$ m    �$
�$ boovtrue�%    o      �#�# 0 
write_file   %&% Z   ''(�"�!' =    )*) o    � �  0 	appending  * m    �
� boovfals( I   #�+,
� .rdwrseofnull���     ****+ o    �� 0 
write_file  , �-�
� 
set2- m    ��  �  �"  �!  & ./. I  ( 3�01
� .rdwrwritnull���     ****0 o   ( )�� 0 
the_string  1 �23
� 
refn2 o   * +�� 0 
write_file  3 �45
� 
wrat4 m   , -�
� rdwreof 5 �6�
� 
as  6 m   . /�
� 
utf8�  / 7�7 I  4 9�8�
� .rdwrclosnull���     ****8 o   4 5�� 0 
write_file  �  �   R      ���

� .ascrerr ****      � ****�  �
   Q   A R9:�	9 I  D I�;�
� .rdwrclosnull���     ****; o   D E�� 0 
write_file  �  : R      ���
� .ascrerr ****      � ****�  �  �	  �*   <=< l     ���  �  = >?> l     � @�   @ ^ X Make sure that the pogo.lib dropbox is mounted. If not then prompt the user to connect.   ? ABA l  � �C��C r   � �DED I  � �������
�� .earslvolutxt  P ��� null��  ��  E o      ���� 0 
volumelist 
volumeList��  B FGF l  � �H��H r   � �IJI m   � ���
�� boovfalsJ o      ���� ,0 dropboxvolumemounted dropboxVolumeMounted��  G KLK l  � �M��M Y   � �N��OP��N Z   � �QR����Q l  � �S��S =   � �TUT n   � �VWV 4   � ���X
�� 
cobjX o   � ����� 0 i  W o   � ����� 0 
volumelist 
volumeListU m   � �YY  dropbox   ��  R r   � �Z[Z m   � ���
�� boovtrue[ o      ���� ,0 dropboxvolumemounted dropboxVolumeMounted��  ��  �� 0 i  O m   � ����� P I  � ���\��
�� .corecnte****       ****\ o   � ����� 0 
volumelist 
volumeList��  ��  ��  L ]^] l  � �_��_ Z   � �`a����` l  � �b��b H   � �cc o   � ����� ,0 dropboxvolumemounted dropboxVolumeMounted��  a I  � ���d��
�� .aevtmvolnull���     TEXTd m   � �ee ) #smb://pogo.lib.virginia.edu/dropbox   ��  ��  ��  ��  ^ fgf l     ������  ��  g hih l     ��j��  j � � Make sure Safari is started and loaded in the background. This may be adequate for making sure that the update of the MySQL db happens.   i klk l  � �m��m O   � �non I  � �������
�� .miscactvnull��� ��� null��  ��  o m   � �H��  l pqp l  �r��r O   �sts r   �uvu m   � ���
�� boovfalsv n      wxw 1   ��
�� 
pvisx 4   � ��y
�� 
prcsy m   � �zz  Safari   t m   � �{{�null     ߀�� 1�System Events.apping sure that the update of the MySQL db happesevs   alis    v  Main                       ��#H+   1�System Events.app                                               K��c��        ����  	                CoreServices    � #c      �c��     1� * (  2Main:System:Library:CoreServices:System Events.app  $  S y s t e m   E v e n t s . a p p  
  M a i n  -System/Library/CoreServices/System Events.app   / ��  ��  q |}| l     ������  ��  } ~~ l     �����  � 9 3 Prompt for the desired project to export form IRIS    ��� l ���� I ����
�� .sysodlogaskr        TEXT� m  
�� > 8Enter the project name to mark as successfully exported:   � �����
�� 
dtxt� m  ��      ��  ��  � ��� l  ���� r   ��� n  ��� 1  ��
�� 
ttxt� l ���� 1  ��
�� 
rslt��  � o      ���� $0 projectnamevalue projectNameValue��  � ��� l     ������  ��  � ��� l     �����  � J D Confirm that step 4 has been approved in the image tracking system.   � ��� l !K���� I !K����
�� .sysodlogaskr        TEXT� m  !$�� | vHave you approved step 4 in the image tracking system? You should not run this script if step 4 has not been approved.   � ����
�� 
btns� J  '/�� ��� m  '*�� 
 Quit   � ���� m  *-��  Proceed   ��  � ����
�� 
dflt� m  25�� 
 Quit   � ����
�� 
cbtn� m  8;�� 
 Quit   � ����
�� 
appr� m  >A��  WARNING   � �����
�� 
givu� m  DE����  ��  ��  � ��� l     ������  ��  � ��� l LU���� r  LU��� I LQ������
�� .misccurdldt    ��� null��  ��  � o      ���� 0 	starttime 	startTime��  � ��� l Vd���� r  Vd��� c  V`��� n V^��� I  W^������� &0 getdatetimestring getDateTimeString� ���� o  WZ���� 0 	starttime 	startTime��  ��  �  f  VW� m  ^_��
�� 
ctxt� o      ���� 0 startdatetime startDateTime��  � ��� l ew���� n ew��� I  fw������� (0 updateprojectonweb updateProjectOnWeb� ��� o  fi���� $0 projectnamevalue projectNameValue� ��� m  ij���� � ��� o  jm���� 0 startdatetime startDateTime� ��� m  mp��      � ���� m  pq����  ��  ��  �  f  ef��  � ��� l     ������  ��  � ��� l     �����  � - ' Begin documenting this script's stats.   � ��� l x����� r  x���� c  x���� b  x���� b  x��� o  x{���� 0 	outputlog 	outputLog� m  {~�� . (Project IRIS Export Date Update - Step 3   � o  ����� 0 newline newLine� m  ����
�� 
ctxt� o      ���� 0 	outputlog 	outputLog��  � ��� l ������ r  ����� c  ����� b  ����� b  ����� b  ����� b  ����� o  ������ 0 	outputlog 	outputLog� m  ����  Start=   � o  ������ 0 	starttime 	startTime� o  ������ 0 newline newLine� o  ������ 0 newline newLine� m  ����
�� 
ctxt� o      ���� 0 	outputlog 	outputLog��  � ��� l ������ r  ����� c  ����� b  ����� b  ����� b  ����� o  ������ 0 	outputlog 	outputLog� m  ����  Project Name=   � o  ������ $0 projectnamevalue projectNameValue� o  ������ 0 newline newLine� m  ����
�� 
ctxt� o      ���� 0 	outputlog 	outputLog��  � � � l     ������  ��     l     ����   B < Identify the archived work and image files for the project.     l ���� r  �� c  ��	
	 b  �� b  �� o  ������ $0 archivedirectory archiveDirectory o  ������ $0 projectnamevalue projectNameValue m  ��  .works   
 m  ����
�� 
ctxt o      ���� (0 irisworkexportfile irisWorkExportFile��    l ���� r  �� c  �� b  �� b  �� o  ������ $0 archivedirectory archiveDirectory o  ������ $0 projectnamevalue projectNameValue m  ��  .images    m  ����
�� 
ctxt o      ���� *0 irisimageexportfile irisImageExportFile��    l     ������  ��    l     �� ��    8 2 Read the works file to identify the work numbers.    !"! l ��#��# r  ��$%$ c  ��&'& n ��()( I  ����*���� 0 	read_file  * +�+ o  ���~�~ (0 irisworkexportfile irisWorkExportFile�  ��  )  f  ��' m  ���}
�} 
ctxt% o      �|�| 0 inputtextfile inputTextFile��  " ,-, l ��.�{. r  ��/0/ c  ��121 n ��343 I  ���z5�y�z 0 splitstring  5 676 o  ���x�x 0 inputtextfile inputTextFile7 8�w8 o  ���v�v 0 newline newLine�w  �y  4  f  ��2 m  ���u
�u 
list0 o      �t�t 0 inputrecords inputRecords�{  - 9:9 l �;�s; r  �<=< c  ��>?> J  ���r�r  ? m  ���q
�q 
list= o      �p�p  0 worknumberlist workNumberList�s  : @A@ l mB�oB Y  mC�nDE�mC k  hFF GHG r  "IJI c  KLK n  MNM 4  �lO
�l 
cobjO o  �k�k 0 linenum lineNumN o  �j�j 0 inputrecords inputRecordsL m  �i
�i 
ctxtJ o      �h�h 0 linedata lineDataH PQP r  #4RSR c  #0TUT I  #.�gV�f�g 0 splitstring  V WXW o  $'�e�e 0 linedata lineDataX Y�dY o  '*�c�c  0 fieldseparator fieldSeparator�d  �f  U m  ./�b
�b 
listS o      �a�a 
0 fields  Q Z�`Z Z  5h[\�_�^[ l 5<]�]] >  5<^_^ o  58�\�\ 0 linedata lineData_ m  8;``      �]  \ Z  ?dab�[�Za l ?Kc�Yc >  ?Kded l ?Gf�Xf n  ?Gghg 4  BG�Wi
�W 
cobji m  EF�V�V h o  ?B�U�U 
0 fields  �X  e m  GJjj      �Y  b r  N`klk c  N\mnm b  NZopo o  NQ�T�T  0 worknumberlist workNumberListp l QYq�Sq n  QYrsr 4  TY�Rt
�R 
cobjt m  WX�Q�Q s o  QT�P�P 
0 fields  �S  n m  Z[�O
�O 
listl o      �N�N  0 worknumberlist workNumberList�[  �Z  �_  �^  �`  �n 0 linenum lineNumD m  �M�M E I �Lu�K
�L .corecnte****       ****u o  �J�J 0 inputrecords inputRecords�K  �m  �o  A vwv l nyx�Ix r  nyyzy I nu�H{�G
�H .corecnte****       ****{ o  nq�F�F  0 worknumberlist workNumberList�G  z o      �E�E 0 	workcount 	workCount�I  w |}| l     �D�C�D  �C  } ~~ l     �B��B  � : 4 Read the images file to identify the image numbers.    ��� l z���A� r  z���� c  z���� n z���� I  {��@��?�@ 0 	read_file  � ��>� o  {~�=�= *0 irisimageexportfile irisImageExportFile�>  �?  �  f  z{� m  ���<
�< 
ctxt� o      �;�; 0 inputtextfile inputTextFile�A  � ��� l ����:� r  ����� c  ����� n ����� I  ���9��8�9 0 splitstring  � ��� o  ���7�7 0 inputtextfile inputTextFile� ��6� o  ���5�5 0 newline newLine�6  �8  �  f  ��� m  ���4
�4 
list� o      �3�3 0 inputrecords inputRecords�:  � ��� l ����2� r  ����� c  ����� J  ���1�1  � m  ���0
�0 
list� o      �/�/ "0 imagenumberlist imageNumberList�2  � ��� l ���.� Y  ���-���,� k  ��� ��� r  ����� c  ����� n  ����� 4  ���+�
�+ 
cobj� o  ���*�* 0 linenum lineNum� o  ���)�) 0 inputrecords inputRecords� m  ���(
�( 
ctxt� o      �'�' 0 linedata lineData� ��� r  ����� c  ����� I  ���&��%�& 0 splitstring  � ��� o  ���$�$ 0 linedata lineData� ��#� o  ���"�"  0 fieldseparator fieldSeparator�#  �%  � m  ���!
�! 
list� o      � �  
0 fields  � ��� Z  ������ l ����� >  ����� o  ���� 0 linedata lineData� m  ����      �  � Z  ������ l ����� >  ����� l ����� n  ����� 4  ����
� 
cobj� m  ���� � o  ���� 
0 fields  �  � m  ����      �  � r  � ��� c  ����� b  ����� o  ���� "0 imagenumberlist imageNumberList� l ����� n  ����� 4  ����
� 
cobj� m  ���� � o  ���� 
0 fields  �  � m  ���
� 
list� o      �� "0 imagenumberlist imageNumberList�  �  �  �  �  �- 0 linenum lineNum� m  ���� � I �����

� .corecnte****       ****� o  ���	�	 0 inputrecords inputRecords�
  �,  �.  � ��� l ��� r  ��� I ���
� .corecnte****       ****� o  �� "0 imagenumberlist imageNumberList�  � o      �� 0 
imagecount 
imageCount�  � ��� l     ���  �  � ��� l     ���  � > 8 Create a date for storage into the export field in IRIS   � ��� l %�� � r  %��� n  !��� 1  !��
�� 
day � o  ���� 0 	starttime 	startTime� o      ���� 0 d  �   � ��� l &1���� r  &1��� n  &-��� m  )-��
�� 
mnth� o  &)���� 0 	starttime 	startTime� o      ���� 0 m  ��  � ��� l 2;���� r  2;��� c  27��� m  25��      � m  56��
�� 
ctxt� o      ���� 0 mnumber mNumber��  � ��� l <-���� Z  <-������ l <C���� =  <C��� o  <?���� 0 m  � m  ?B��
�� 
jan ��  � r  FM   m  FI  1    o      ���� 0 mnumber mNumber�  l PW�� =  PW o  PS���� 0 m   m  SV��
�� 
feb ��   	 r  Za

 m  Z]  2    o      ���� 0 mnumber mNumber	  l dk�� =  dk o  dg���� 0 m   m  gj��
�� 
mar ��    r  nu m  nq  3    o      ���� 0 mnumber mNumber  l x�� =  x o  x{���� 0 m   m  {~��
�� 
apr ��    r  �� m  ��    4    o      ���� 0 mnumber mNumber !"! l ��#��# =  ��$%$ o  ������ 0 m  % m  ����
�� 
may ��  " &'& r  ��()( m  ��**  5   ) o      ���� 0 mnumber mNumber' +,+ l ��-��- =  ��./. o  ������ 0 m  / m  ����
�� 
jun ��  , 010 r  ��232 m  ��44  6   3 o      ���� 0 mnumber mNumber1 565 l ��7��7 =  ��898 o  ������ 0 m  9 m  ����
�� 
jul ��  6 :;: r  ��<=< m  ��>>  7   = o      ���� 0 mnumber mNumber; ?@? l ��A��A =  ��BCB o  ������ 0 m  C m  ����
�� 
aug ��  @ DED r  ��FGF m  ��HH  8   G o      ���� 0 mnumber mNumberE IJI l ��K��K =  ��LML o  ������ 0 m  M m  ����
�� 
sep ��  J NON r  ��PQP m  ��RR  9   Q o      ���� 0 mnumber mNumberO STS l ��U��U =  ��VWV o  ������ 0 m  W m  ����
�� 
oct ��  T XYX r  �Z[Z m  ��\\  10   [ o      ���� 0 mnumber mNumberY ]^] l _��_ =  `a` o  ���� 0 m  a m  
��
�� 
nov ��  ^ bcb r  ded m  ff  11   e o      ���� 0 mnumber mNumberc ghg l i��i =  jkj o  ���� 0 m  k m  ��
�� 
dec ��  h l��l r  ")mnm m  "%oo  12   n o      ���� 0 mnumber mNumber��  ��  ��  � pqp l .9r��r r  .9sts n  .5uvu 1  15��
�� 
yearv o  .1���� 0 	starttime 	startTimet o      ���� 0 y  ��  q wxw l :Sy��y r  :Sz{z c  :O|}| b  :M~~ b  :I��� b  :E��� b  :A��� o  :=���� 0 mnumber mNumber� m  =@��  /   � o  AD���� 0 d  � m  EH��  /    o  IL���� 0 y  } m  MN��
�� 
ctxt{ o      ���� 0 
exportdate 
exportDate��  x ��� l     ������  ��  � ��� l T����� t  T���� k  X��� ��� O  X���� k  ^��� ��� l ^^�����  � ? 9open irisDirectory & irisWorks with password irisPassword   � ��� I ^g�����
�� .GURLGURLnull��� ��� TEXT� b  ^c��� o  ^_���� (0 irisremotelocation irisRemoteLocation� o  _b���� 0 	irisworks 	irisWorks��  � ��� r  hu��� l hq���� N  hq�� 4  hp���
�� 
cDB � o  lo���� 0 	irisworks 	irisWorks��  � o      ���� 0 irisworksdb irisWorksDB� ��� Z  v�������� = v��� l v}���� I v}�����
�� .coredoexbool        obj � o  vy���� 0 irisworksdb irisWorksDB��  ��  � m  }~��
�� boovfals� k  ���� ��� I �������
�� .sysodlogaskr        TEXT� b  ����� b  ����� m  ���� % There is a problem finding the    � o  ������ 0 	irisworks 	irisWorks� m  ���� F @ file. Click Cancel and resolve this, then run the script again.   ��  � ���� L  ������  ��  ��  ��  � ��� l �������  � B <open irisDirectory & irisSurrogat with password irisPassword   � ��� I �������
�� .GURLGURLnull��� ��� TEXT� b  ����� o  ������ (0 irisremotelocation irisRemoteLocation� o  ������ 0 irissurrogat irisSurrogat��  � ��� r  ����� l ������ N  ���� 4  �����
�� 
cDB � o  ������ 0 irissurrogat irisSurrogat��  � o      ����  0 irissurrogatdb irisSurrogatDB� ���� Z  ��������� = ����� l ������ I �������
�� .coredoexbool        obj � o  ������ 0 irisworksdb irisWorksDB��  ��  � m  ����
�� boovfals� k  ���� ��� I �������
�� .sysodlogaskr        TEXT� b  ����� b  ����� m  ���� % There is a problem finding the    � o  ������ 0 irissurrogat irisSurrogat� m  ���� F @ file. Click Cancel and resolve this, then run the script again.   ��  � ���� L  ������  ��  ��  ��  ��  � m  X[�� ��� l ��������  ��  � ��� l �������  � : 4 Loop through the works and update the export dates.   � ��� Y  ���������� k  ���� ��� r  ����� n  ����� 4  �����
�� 
cobj� o  ������ 0 i  � o  ������  0 worknumberlist workNumberList� o      ���� 0 workno workNo� ���� n ����� I  �������� ,0 updateworkexportdate updateWorkExportDate� ��� o  ���~�~ 0 workno workNo� ��}� o  ���|�| 0 
exportdate 
exportDate�}  �  �  f  ����  �� 0 i  � m  ���{�{ � o  ���z�z 0 	workcount 	workCount��  � ��� l ���y�x�y  �x  � ��� l ���w��w  � ; 5 Loop through the images and update the export dates.   � ��� Y  �(��v���u� k  #�� ��� r  ��� n     4  �t
�t 
cobj o  �s�s 0 i   o  �r�r "0 imagenumberlist imageNumberList� o      �q�q 0 imageno imageNo� �p n # I  #�o�n�o .0 updateimageexportdate updateImageExportDate  o  �m�m 0 imageno imageNo 	�l	 o  �k�k 0 
exportdate 
exportDate�l  �n    f  �p  �v 0 i  � m  �j�j � o  �i�i 0 
imagecount 
imageCount�u  � 

 l ))�h�g�h  �g    r  )> c  ): b  )8 b  )4 b  )0 o  ),�f�f 0 	outputlog 	outputLog m  ,/   Updated Work Record Count=    o  03�e�e $0 updatedworkcount updatedWorkCount o  47�d�d 0 newline newLine m  89�c
�c 
ctxt o      �b�b 0 	outputlog 	outputLog  r  ?T c  ?P b  ?N  b  ?J!"! b  ?F#$# o  ?B�a�a 0 	outputlog 	outputLog$ m  BE%% ! Updated Image Record Count=   " o  FI�`�` &0 updatedimagecount updatedImageCount  o  JM�_�_ 0 newline newLine m  NO�^
�^ 
ctxt o      �]�] 0 	outputlog 	outputLog &'& r  Uj()( c  Uf*+* b  Ud,-, b  U`./. b  U\010 o  UX�\�\ 0 	outputlog 	outputLog1 m  X[22  Error Count=   / o  \_�[�[ 0 
errorcount 
errorCount- o  `c�Z�Z 0 newline newLine+ m  de�Y
�Y 
ctxt) o      �X�X 0 	outputlog 	outputLog' 343 r  kt565 I kp�W�V�U
�W .misccurdldt    ��� null�V  �U  6 o      �T�T 0 endtime endTime4 787 r  u�9:9 c  u�;<; b  u�=>= b  u�?@? b  u�ABA b  u|CDC o  ux�S�S 0 	outputlog 	outputLogD o  x{�R�R 0 newline newLineB m  |EE 
 End=   @ o  ���Q�Q 0 endtime endTime> o  ���P�P 0 newline newLine< m  ���O
�O 
ctxt: o      �N�N 0 	outputlog 	outputLog8 FGF r  ��HIH c  ��JKJ n ��LML I  ���MN�L�M &0 getdatetimestring getDateTimeStringN O�KO o  ���J�J 0 endtime endTime�K  �L  M  f  ��K m  ���I
�I 
ctxtI o      �H�H 0 enddatetime endDateTimeG PQP n ��RSR I  ���GT�F�G (0 updateprojectonweb updateProjectOnWebT UVU o  ���E�E $0 projectnamevalue projectNameValueV WXW m  ���D�D X YZY m  ��[[      Z \]\ o  ���C�C 0 enddatetime endDateTime] ^�B^ o  ���A�A 0 
errorcount 
errorCount�B  �F  S  f  ��Q _`_ Z  ��ab�@�?a l ��c�>c >  ��ded o  ���=�= 0 
errorcount 
errorCounte m  ���<�<  �>  b r  ��fgf c  ��hih b  ��jkj b  ��lml o  ���;�; 0 	outputlog 	outputLogm o  ���:�: 0 newline newLinek o  ���9�9 0 errorlog errorLogi m  ���8
�8 
ctxtg o      �7�7 0 	outputlog 	outputLog�@  �?  ` non n ��pqp I  ���6r�5�6 $0 sendemailmessage sendEmailMessager sts o  ���4�4 $0 fromemailaddress fromEmailAddresst uvu o  ���3�3 (0 toemailaddresslist toEmailAddressListv w�2w o  ���1�1 0 	outputlog 	outputLog�2  �5  q  f  ��o x�0x O  ��yzy I ���/{|
�/ .sysodlogaskr        TEXT{ m  ��}} 2 ,IRIS project export date update is complete!   | �.~
�. 
btns~ J  ���� ��-� m  ����  OK   �-   �,��
�, 
dflt� m  ����  OK   � �+��*
�+ 
givu� m  ���)�)  �*  z m  ����0  � m  TW�(�(p��  � ��'� l     �&�%�&  �%  �'       �$��������������$  � �#�"�!� ���������# &0 getdatetimestring getDateTimeString�" 40 getemaildistributionlist getEmailDistributionList�! 
0 joinby  �  0 	read_file  � $0 sendemailmessage sendEmailMessage� ,0 sendemailmessage_old sendEmailMessage_old� 0 splitstring  � (0 updateprojectonweb updateProjectOnWeb� .0 updateimageexportdate updateImageExportDate� ,0 updateworkexportdate updateWorkExportDate� 0 write_to_file  
� .aevtoappnull  �   � ****� � ������� &0 getdatetimestring getDateTimeString� ��� �  �� 0 
dateobject 
dateObject�  � ��������
�	����� 0 
dateobject 
dateObject� 0 d  � 0 daystr dayStr� 0 m  � 0 monstr monStr� 0 y  � 0 secs  �
 0 hrstr hrStr�	 0 min  � 0 minstr minStr� 0 secstr secStr�  0 datetimestring dateTimeString� 0 h  � +��	��� ��(��2��<��F��P��Z��d��n��x�������������������
� 
day � 

� 
ctxt
� 
mnth
�  
jan 
�� 
feb 
�� 
mar 
�� 
apr 
�� 
may 
�� 
jun 
�� 
jul 
�� 
aug 
�� 
sep 
�� 
oct 
�� 
nov 
�� 
dec 
�� 
year
�� 
time���� <����,E�O�� �%�&E�Y ��&E�O��,E�O��  �E�Y ���  �E�Y ���  �E�Y ���  �E�Y }��  �E�Y q��  
a E�Y c�a   
a E�Y S�a   
a E�Y C�a   
a E�Y 3�a   
a E�Y #�a   
a E�Y �a   
a E�Y hO�a ,E�O�a ,E�O�a  ,�a "E�O�a #E�O�� a  �%�&E�Y ��&E�Y a !E�O�a " ,�a ""E�O�a "#E�O�� a #�%�&E�Y ��&E�Y a $E�O�� a %�%�&E�Y ��&E�O�a &%�%a '%�%a (%�%a )%�%a *%�%�&E�� ��%���������� 40 getemaildistributionlist getEmailDistributionList�� ����� �  ����  0 configfilename configFileName��  � ������������������  0 configfilename configFileName�� 0 pathtoscript pathToScript�� 0 pathlist pathList�� 0 	pathcount 	pathCount�� "0 emailconfigfile emailConfigFile�� 0 i  �� (0 emailaddressstring emailAddressString�� 0 	emaillist 	emailList� ������E������Q��c���
�� 
rtyp
�� 
ctxt
�� .earsffdralis        afdr�� 0 splitstring  
�� 
list
�� .corecnte****       ****
�� 
cobj�� 0 	read_file  �� a)��l E�O)��l+ �&E�O�j E�O��&E�O k�kkh ���/%�%�&E�[OY��O��%�&E�O)�k+ 
�&E�O)��l+ �&E�� ������������� 
0 joinby  �� ����� �  ������ 0 somestrings  �� 	0 delim  ��  � ���������� 0 somestrings  �� 	0 delim  �� 0 olddelim oldDelim�� 
0 retval  � ����������
�� 
ascr
�� 
txdl
�� 
TEXT��  ��  �� + ��,E�O���,FO��&E�O���,FW X  ���,FO�� ������������� 0 	read_file  �� ����� �  ���� 0 the_file  ��  � ���������� 0 the_file  �� 0 file_contents  �� 0 
input_file  �� 0 	file_size  � �������������������������������
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
�j W X  hO�� ������������ $0 sendemailmessage sendEmailMessage�� ����� �  �������� 0 fromaddress fromAddress�� 0 toaddresslist toAddressList�� 0 messagebody messageBody��  � ���������������� 0 fromaddress fromAddress�� 0 toaddresslist toAddressList�� 0 messagebody messageBody�� 0 sendmail  �� 0 message  �� 0 i  �� 0 commandline commandLine� 	C#*������?@���� 
0 joinby  �� 0 newline newLine
�� 
ctxt
�� .sysoexecTEXT���     TEXT�� -� )�)��l+ %�%�&E�O��&E�O�%�%�%�&E�O�j U� ��L���������� ,0 sendemailmessage_old sendEmailMessage_old�� ����� �  �������� 0 fromaddress fromAddress�� 0 toaddresslist toAddressList�� 0 messagebody messageBody��  � �������������� 0 fromaddress fromAddress�� 0 toaddresslist toAddressList�� 0 messagebody messageBody�� 0 
newmessage 
newMessage�� 0 i  �� 0 emailaddress emailAddress� ���������m����������������������������
�� 
kocl
�� 
bcke
�� 
prdt
�� 
subj
�� 
ctnt
�� 
sndr�� �� 
�� .corecrel****      � null
�� .corecnte****       ****
�� 
cobj
�� 
trcp
�� 
insh
�� 
radd
�� .emsgsendnull���     mssg��  ��  
� .sysodlogaskr        TEXT�� a� ]*��������� 
E�O /k�j kh ��/E�O� *���*�-5��l� 
U[OY��O 
�j W X  a j U� �~��}�|���{�~ 0 splitstring  �} �z��z �  �y�x�y 0 
somestring  �x 	0 delim  �|  � �w�v�u�t�w 0 
somestring  �v 	0 delim  �u 0 olddelim oldDelim�t 0 retvals  � �s�r�q�p�o
�s 
ascr
�r 
txdl
�q 
citm�p  �o  �{ + ��,E�O���,FO��-E�O���,FW X  ���,FO�� �n��m�l���k�n (0 updateprojectonweb updateProjectOnWeb�m �j��j �  �i�h�g�f�e�i 0 projname projName�h 0 stepnum stepNum�g 0 	starttime 	startTime�f 0 
finishtime 
finishTime�e 0 
errorcount 
errorCount�l  � �d�c�b�a�`�_�^�d 0 projname projName�c 0 stepnum stepNum�b 0 	starttime 	startTime�a 0 
finishtime 
finishTime�` 0 
errorcount 
errorCount�_ 0 urltext urlText�^ 0 i  � �]��\�[%.9H�Z�Y�X�] .0 imageprojectstatusurl imageProjectStatusURL
�\ 
ctxt
�[ 
bool
�Z .GURLGURLnull��� ��� TEXT�Y 

�X .aevtquitnull���    obj �k ���%�%�&E�O�k 
 �l �&
 �m �& ��%�%�&E�Y hO�� ��%�%�&E�Y hO�� ��%�%�&E�Y hO��%�%�&E�O� �j O k�kh hY��O*j U� �WQ�V�U���T�W .0 updateimageexportdate updateImageExportDate�V �S��S �  �R�Q�R 0 imagenum imageNum�Q $0 exportdatestring exportDateString�U  � �P�O�P 0 imagenum imageNum�O $0 exportdatestring exportDateString� ��N�M�L�Ko�J�I�H��G�F��E�D�C�B��A�@�?
�N 
cDB �M 0 irissurrogat irisSurrogat
�L 
cRQT
�K 
ccel
�J 
cwin
�I .FMPRFINDnull���    obj 
�H 
pCRW
�G 
vlue
�F .coredoexbool        obj �E &0 updatedimagecount updatedImageCount�D  �C  �B 0 errorlog errorLog�A 0 newline newLine
�@ 
ctxt�? 0 
errorcount 
errorCount�T n� j*��/ b ;�*�k/��/FO*�k/j O*�,��/�,j  �*�,��/�,FO�kE�Y hW &X  _ a %�%_ %a &E` O_ kE` UU� �>��=�<���;�> ,0 updateworkexportdate updateWorkExportDate�= �:��: �  �9�8�9 0 worknum workNum�8 $0 exportdatestring exportDateString�<  � �7�6�7 0 worknum workNum�6 $0 exportdatestring exportDateString� ��5�4�3�2��1�0�/��.�-��,�+�*�)��(�'�&
�5 
cDB �4 0 	irisworks 	irisWorks
�3 
cRQT
�2 
ccel
�1 
cwin
�0 .FMPRFINDnull���    obj 
�/ 
pCRW
�. 
vlue
�- .coredoexbool        obj �, $0 updatedworkcount updatedWorkCount�+  �*  �) 0 errorlog errorLog�( 0 newline newLine
�' 
ctxt�& 0 
errorcount 
errorCount�; n� j*��/ b ;�*�k/��/FO*�k/j O*�,��/�,j  �*�,��/�,FO�kE�Y hW &X  _ a %�%_ %a &E` O_ kE` UU� �%
�$�#���"�% 0 write_to_file  �$ �!��! �  � ���  0 the_file  � 0 
the_string  � 0 	appending  �#  � ����� 0 the_file  � 0 
the_string  � 0 	appending  � 0 
write_file  � ����������������

� 
TEXT
� 
file
� 
perm
� .rdwropenshor       file
� 
set2
� .rdwrseofnull���     ****
� 
refn
� 
wrat
� rdwreof 
� 
as  
� 
utf8� 
� .rdwrwritnull���     ****
� .rdwrclosnull���     ****�  �
  �" S��&E�O 5*�/�el E�O�f  ��jl Y hO������� O�j W X   
�j W X  h� �	������
�	 .aevtoappnull  �   � ****� k    ���  L��  U��  c��  l��  t��  |��  ���  ���  ���  ���  ���  ���  ���  ���  ���  ���  ���  ��� A�� F�� K�� ]�� k�� p�� ��� ��� ��� ��� ��� ��� ��� ��� ��� �� �� !�� ,�� 9�� @�� v�� ��� ��� ��� ��� ��� ��� ��� ��� ��� p�� w�� ���  �  �  � ��� 0 i  � 0 linenum lineNum� � Q� ^ _� h�  s���� {�� ������� ��� ����������������� ��� �����������������������Ye��H��{��z����������������������������������������������������������������`j����������������������� ��*��4��>��H��R��\��f��o���������������������������������%2��E��[��}����� 0 irispassword irisPassword� (0 irisremotelocation irisRemoteLocation�  $0 archivedirectory archiveDirectory
�� 
ctxt�� .0 imageprojectstatusurl imageProjectStatusURL�� $0 fromemailaddress fromEmailAddress�� 40 getemaildistributionlist getEmailDistributionList
�� 
list�� (0 toemailaddresslist toEmailAddressList�� 0 	irisworks 	irisWorks�� 0 irissurrogat irisSurrogat�� 	
�� .sysontocTEXT       shor��  0 fieldseparator fieldSeparator�� ��  0 valueseparator valueSeparator�� 
�� 0 newline newLine�� 0 	outputlog 	outputLog�� 0 errorlog errorLog�� 0 
errorcount 
errorCount�� 0 	workcount 	workCount�� $0 updatedworkcount updatedWorkCount�� 0 
imagecount 
imageCount�� &0 updatedimagecount updatedImageCount
�� .earslvolutxt  P ��� null�� 0 
volumelist 
volumeList�� ,0 dropboxvolumemounted dropboxVolumeMounted
�� .corecnte****       ****
�� 
cobj
�� .aevtmvolnull���     TEXT
�� .miscactvnull��� ��� null
�� 
prcs
�� 
pvis
�� 
dtxt
�� .sysodlogaskr        TEXT
�� 
rslt
�� 
ttxt�� $0 projectnamevalue projectNameValue
�� 
btns
�� 
dflt
�� 
cbtn
�� 
appr
�� 
givu
�� .misccurdldt    ��� null�� 0 	starttime 	startTime�� &0 getdatetimestring getDateTimeString�� 0 startdatetime startDateTime�� �� (0 updateprojectonweb updateProjectOnWeb�� (0 irisworkexportfile irisWorkExportFile�� *0 irisimageexportfile irisImageExportFile�� 0 	read_file  �� 0 inputtextfile inputTextFile�� 0 splitstring  �� 0 inputrecords inputRecords��  0 worknumberlist workNumberList�� 0 linedata lineData�� 
0 fields  �� "0 imagenumberlist imageNumberList
�� 
day �� 0 d  
�� 
mnth�� 0 m  �� 0 mnumber mNumber
�� 
jan 
�� 
feb 
�� 
mar 
�� 
apr 
�� 
may 
�� 
jun 
�� 
jul 
�� 
aug 
�� 
sep 
�� 
oct 
�� 
nov 
�� 
dec 
�� 
year�� 0 y  �� 0 
exportdate 
exportDate��p
�� .GURLGURLnull��� ��� TEXT
�� 
cDB �� 0 irisworksdb irisWorksDB
�� .coredoexbool        obj ��  0 irissurrogatdb irisSurrogatDB�� 0 workno workNo�� ,0 updateworkexportdate updateWorkExportDate�� 0 imageno imageNo�� .0 updateimageexportdate updateImageExportDate�� 0 endtime endTime�� 0 enddatetime endDateTime�� $0 sendemailmessage sendEmailMessage�� � �E�O��%�%E�O�E�O��&E�O��&E�O)�k+ �&E�Oa E` Oa E` Oa j �&E` Oa j �&E` Oa j �&E` Oa �&E` Oa �&E` OjE` OjE`  OjE` !OjE` "OjE` #O*j $E` %OfE` &O ,k_ %j 'kh  _ %a (�/a )  
eE` &Y h[OY��O_ & a *j +Y hOa , *j -UOa . f*a /a 0/a 1,FUOa 2a 3a 4l 5O_ 6a 7,E` 8Oa 9a :a ;a <lva =a >a ?a @a Aa Ba Cja  5O*j DE` EO)_ Ek+ F�&E` GO)_ 8m_ Ga Hja I+ JO_ a K%_ %�&E` O_ a L%_ E%_ %_ %�&E` O_ a M%_ 8%_ %�&E` O�_ 8%a N%�&E` OO�_ 8%a P%�&E` QO)_ Ok+ R�&E` SO)_ S_ l+ T�&E` UOjv�&E` VO hl_ Uj 'kh _ Ua (�/�&E` WO*_ W_ l+ T�&E` XO_ Wa Y *_ Xa (k/a Z _ V_ Xa (k/%�&E` VY hY h[OY��O_ Vj 'E`  O)_ Qk+ R�&E` SO)_ S_ l+ T�&E` UOjv�&E` [O hl_ Uj 'kh _ Ua (�/�&E` WO*_ W_ l+ T�&E` XO_ Wa \ *_ Xa (m/a ] _ [_ Xa (m/%�&E` [Y hY h[OY��O_ [j 'E` "O_ Ea ^,E` _O_ Ea `,E` aOa b�&E` cO_ aa d  a eE` cY �_ aa f  a gE` cY �_ aa h  a iE` cY �_ aa j  a kE` cY �_ aa l  a mE` cY �_ aa n  a oE` cY {_ aa p  a qE` cY g_ aa r  a sE` cY S_ aa t  a uE` cY ?_ aa v  a wE` cY +_ aa x  a yE` cY _ aa z  a {E` cY hO_ Ea |,E` }O_ ca ~%_ _%a %_ }%�&E` �Oa �na � w�_ %j �O*a �_ /E` �O_ �j �f  a �_ %a �%j 5OhY hO�_ %j �O*a �_ /E` �O_ �j �f  a �_ %a �%j 5OhY hUO (k_  kh  _ Va (�/E` �O)_ �_ �l+ �[OY��O (k_ "kh  _ [a (�/E` �O)_ �_ �l+ �[OY��O_ a �%_ !%_ %�&E` O_ a �%_ #%_ %�&E` O_ a �%_ %_ %�&E` O*j DE` �O_ _ %a �%_ �%_ %�&E` O)_ �k+ F�&E` �O)_ 8ma �_ �_ a I+ JO_ j _ _ %_ %�&E` Y hO)��_ m+ �Oa � a �a :a �kva =a �a Cja � 5Uoascr  ��ޭ