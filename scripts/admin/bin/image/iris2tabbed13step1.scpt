FasdUAS 1.101.10   ��   ��    k             l     �� ��    J D License and Copyright: The contents of this file are subject to the       	  l     �� 
��   
 O I Educational Community License (the "License"); you may not use this file    	     l     �� ��    R L except in compliance with the License. You may obtain a copy of the License         l     �� ��    5 / at http://www.opensource.org/licenses/ecl1.txt         l     ������  ��        l     �� ��    Q K Software distributed under the License is distributed on an "AS IS" basis,         l     �� ��    S M WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for         l     �� ��    T N the specific language governing rights and limitations under the License.</p>         l     ������  ��        l     ��  ��     M G The entire file consists of original code.  Copyright (c) 2002-2005 by      ! " ! l     �� #��   # = 7 The Rector and Visitors of the University of Virginia.    "  $ % $ l     �� &��   &   All rights reserved.    %  ' ( ' l     ������  ��   (  ) * ) l     �� +��   + !  Script: iris2tabbed13step1    *  , - , l     �� .��   . ] W Description: This script extracts IRIS work data for mapping to GDMS into a flat file.    -  / 0 / l     �� 1��   1 M G		Data is written out to a tab delimited file for use by a Perl Script.    0  2 3 2 l     �� 4��   4 R L		A small log file documenting the number of works processed is written out.    3  5 6 5 l     �� 7��   7 1 +		The IRIS export date fields are modified.    6  8 9 8 l     ������  ��   9  : ; : l     �� <��   < a [ NOTE: Make sure to set the irisPassword field to a valid value that allows for logging in.    ;  = > = l     ������  ��   >  ? @ ? l     �� A��   A / ) Author: Jack Kelly  <jlk4p@virginia.edu>    @  B C B l     ������  ��   C  D E D l     �� F��   F ] W 2006/05/16 - (jlk4p) Make changes to resolve the timeout issue by increasing time out     E  G H G l     �� I��   I @ :             seconds and removing display dialog commands.    H  J K J l     �� L��   L ` Z 2006/05/16 - (jlk4p) Modify the exported data for site to be some concatenation of site,     K  M N M l     �� O��   O W Q           region, and country such that the site does not contain abbreviations.    N  P Q P l     �� R��   R � } 2006/06/13 - (jlk4p) Added process to update a MySQL db so that the status of this script can be determined from a web page.    Q  S T S l     �� U��   U � } 2006/06/26 - (jlk4p) Add a check to see if the dropbox volume is already mounted and if not then prompt the user to connect.    T  V W V l     �� X��   X p j 2006/08/01 - (jlk4p) Updated the outputDirectory to reflect the new directory structure for sharing data.    W  Y Z Y l     �� [��   [ � { 2007/01/23 - (jlk4p) Updated work statistics to include work number warning message when work is not approved for project.    Z  \ ] \ l     ������  ��   ]  ^ _ ^ l     `�� ` r      a b a m      c c  master    b o      ���� 0 irispassword irisPassword��   _  d e d l    f�� f r     g h g b    	 i j i b     k l k m     m m  FMP5://    l o    ���� 0 irispassword irisPassword j m     n n  @udon.lib.virginia.edu/    h o      ���� (0 irisremotelocation irisRemoteLocation��   e  o p o l     �� q��   q 8 2set irisDirectory to "Main:Users:jlk4p:data:IRIS:"    p  r s r l    t�� t r     u v u m     w w 7 1Main:Volumes:DROPBOX:inbox:finearts:iris_exports:    v o      ���� "0 outputdirectory outputDirectory��   s  x y x l     �� z��   z m gset imageProjectStatusURL to "http://localhost/~jlk4p/dlps/updateImageProjectExportStatus.php?" as text    y  { | { l    }�� } r     ~  ~ c     � � � m     � � i chttp://alioth.lib.virginia.edu/dlps/uva-only/applescript_status/updateImageProjectExportStatus.php?    � m    ��
�� 
ctxt  o      ���� .0 imageprojectstatusurl imageProjectStatusURL��   |  � � � l     ������  ��   �  � � � l    ��� � r     � � � m     � �  	WORKS.fp5    � o      ���� 0 	irisworks 	irisWorks��   �  � � � l    ��� � r     � � � m     � �  WCREATOR.fp5    � o      ���� 0 iriswcreator irisWCreator��   �  � � � l   ! ��� � r    ! � � � m     � �  WORKTYPE.fp5    � o      ���� 0 irisworktype irisWorkType��   �  � � � l  " ) ��� � r   " ) � � � m   " % � �  
TITLES.fp5    � o      ���� 0 
iristitles 
irisTitles��   �  � � � l  * 1 ��� � r   * 1 � � � m   * - � �  CULTURE.fp5    � o      ���� 0 irisculture irisCulture��   �  � � � l  2 9 ��� � r   2 9 � � � m   2 5 � �  
PERIOD.fp5    � o      ���� 0 
irisperiod 
irisPeriod��   �  � � � l  : A ��� � r   : A � � � m   : = � �  SUBJECT.fp5    � o      ���� 0 irissubject irisSubject��   �  � � � l  B I ��� � r   B I � � � m   B E � �  SUBTYPE.fp5    � o      ���� 0 irissubtype irisSubtype��   �  � � � l  J Q ��� � r   J Q � � � m   J M � �  CREATION.fp5    � o      ���� 0 iriscreation irisCreation��   �  � � � l  R Y ��� � r   R Y � � � m   R U � �  REPOSIT.fp5    � o      ����  0 irisrepository irisRepository��   �  � � � l  Z a ��� � r   Z a � � � m   Z ] � �  SITE.fp5    � o      ���� 0 irissite irisSite��   �  � � � l  b i ��� � r   b i � � � m   b e � �  Iris2tabbed.out    � o      ���� 40 outputstatisticsfilename outputStatisticsFilename��   �  � � � l  j q ��� � r   j q � � � m   j m � �  IrisWorkNos.txt    � o      ���� $0 outputworknofile outputWorkNoFile��   �  � � � l  r y ��� � r   r y � � � m   r u � �  IrisWorksExport.err    � o      ���� 0 errorlog errorLog��   �  � � � l  z � � � � r   z � � � � c   z � � � � l  z � ��� � I  z ��� ���
�� .sysontocTEXT       shor � m   z }���� 	��  ��   � m   � ���
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
errorCount��   �  � � � l  � � ��� � r   � � � � � m   � �����   � o      ���� $0 projectworkcount projectWorkCount��   �    l     ������  ��    l     ����   � � getCreatorAuthority retrieves the authority value for each creator ID specified in the list passed. A list of authority values is returned that correlates to the list of creator IDs.     i      I      ��	���� *0 getcreatorauthority getCreatorAuthority	 
��
 o      ���� 0 creatorlist creatorList��  ��   k     �  p       ���� 0 iriscreation irisCreation ���� "0 outputdirectory outputDirectory ���� 0 newline newLine ���� 0 errorlog errorLog ���� 0 
errorcount 
errorCount ������ 0 
worknumber 
workNumber��    q       ���� 0 authoritylist authorityList ���� 0 creatorcount creatorCount ���� 0 i   ������ 0 	authority  ��    O     � O    � k    �   !"! r    #$# c    %&% J    ����  & m    ��
�� 
list$ o      �� 0 authoritylist authorityList" '(' r    )*) I   �~+�}
�~ .corecnte****       ****+ o    �|�| 0 creatorlist creatorList�}  * o      �{�{ 0 creatorcount creatorCount( ,�z, Y    �-�y./�x- k   $ �00 121 r   $ )343 c   $ '565 m   $ %77      6 m   % &�w
�w 
ctxt4 o      �v�v 0 	authority  2 898 r   * 2:;: c   * 0<=< n   * .>?> 4   + .�u@
�u 
cobj@ o   , -�t�t 0 i  ? o   * +�s�s 0 creatorlist creatorList= m   . /�r
�r 
ctxt; o      �q�q 0 	creatorid 	creatorID9 ABA Q   3 �CDEC Z   6 zFG�p�oF l  6 9H�nH >   6 9IJI l  6 7K�mK o   6 7�l�l 0 	creatorid 	creatorID�m  J m   7 8LL      �n  G k   < vMM NON r   < GPQP c   < ?RSR o   < =�k�k 0 	creatorid 	creatorIDS m   = >�j
�j 
ctxtQ n      TUT 4   C F�iV
�i 
ccelV m   D EWW  
Creator ID   U 4   ? C�hX
�h 
cRQTX m   A B�g�g O YZY I  H P�f[�e
�f .FMPRFINDnull���    obj [ 4   H L�d\
�d 
cwin\ m   J K�c�c �e  Z ]�b] Z   Q v^_�a�`^ l  Q _`�_` I  Q _�^a�]
�^ .coredoexbool        obj a l  Q [b�\b n   Q [cdc 1   W [�[
�[ 
vlued n   Q Wefe 4   T W�Zg
�Z 
ccelg m   U Vhh  
Creator ID   f 1   Q T�Y
�Y 
pCRW�\  �]  �_  _ r   b riji c   b pklk n   b nmnm 1   j n�X
�X 
vluen n   b jopo 4   e j�Wq
�W 
ccelq m   f irr  	Authority   p 1   b e�V
�V 
pCRWl m   n o�U
�U 
ctxtj o      �T�T 0 	authority  �a  �`  �b  �p  �o  D R      �S�R�Q
�S .ascrerr ****      � ****�R  �Q  E k   � �ss tut r   � �vwv c   � �xyx m   � �zz      y m   � ��P
�P 
ctxtw o      �O�O 0 	authority  u {|{ r   � �}~} [   � �� o   � ��N�N 0 
errorcount 
errorCount� m   � ��M�M ~ o      �L�L 0 
errorcount 
errorCount| ��K� n  � ���� I   � ��J��I�J 0 write_to_file  � ��� l  � ���H� b   � ���� o   � ��G�G "0 outputdirectory outputDirectory� o   � ��F�F 0 errorlog errorLog�H  � ��� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� m   � ���      � o   � ��E�E 0 
errorcount 
errorCount� m   � ��� 	 : (   � o   � ��D�D 0 
worknumber 
workNumber� m   � ��� . () Unable to get authority for creator ID   � o   � ��C�C 0 	creatorid 	creatorID� o   � ��B�B 0 newline newLine� ��A� m   � ��@
�@ boovtrue�A  �I  �  f   � ��K  B ��?� r   � ���� c   � ���� b   � ���� o   � ��>�> 0 authoritylist authorityList� o   � ��=�= 0 	authority  � m   � ��<
�< 
list� o      �;�; 0 authoritylist authorityList�?  �y 0 i  . m    �:�: / o    �9�9 0 creatorcount creatorCount�x  �z   4    �8�
�8 
cDB � o    �7�7 0 iriscreation irisCreation m     ���null     ߀�� AFileMaker Pro.app�]m �a�Կ�א    p(   )       �(�\�������FMP5   alis    �  Main                       ��#H+   AFileMaker Pro.app                                               Aں� v & � �����  	                FileMaker Pro 6 Folder    � #c      �L3     A     :Main:Applications:FileMaker Pro 6 Folder:FileMaker Pro.app  $  F i l e M a k e r   P r o . a p p  
  M a i n  5Applications/FileMaker Pro 6 Folder/FileMaker Pro.app   / ��   ��6� L   � ��� o   � ��5�5 0 authoritylist authorityList�6   ��� l     �4�3�4  �3  � ��� l     �2��2  � � � getCultureAuthority retrieves the authority value for each culture specified in the list passed. A list of authority values is returned that correlates to the list of cultures.   � ��� i    ��� I      �1��0�1 *0 getcultureauthority getCultureAuthority� ��/� o      �.�. 0 culturelist cultureList�/  �0  � k     ��� ��� p      �� �-��- 0 irisculture irisCulture� �,��, "0 outputdirectory outputDirectory� �+��+ 0 newline newLine� �*��* 0 errorlog errorLog� �)��) 0 
errorcount 
errorCount� �(�'�( 0 
worknumber 
workNumber�'  � ��� q      �� �&��& 0 authoritylist authorityList� �%��% 0 culturecount cultureCount� �$��$ 0 i  � �#�"�# 0 	authority  �"  � ��� O     ���� O    ���� k    ��� ��� r    ��� c    ��� J    �!�!  � m    � 
�  
list� o      �� 0 authoritylist authorityList� ��� r    ��� I   ���
� .corecnte****       ****� o    �� 0 culturelist cultureList�  � o      �� 0 culturecount cultureCount� ��� Y    ������� k   $ ��� ��� r   $ )��� c   $ '��� m   $ %��      � m   % &�
� 
ctxt� o      �� 0 	authority  � ��� Q   * ����� Z   - w����� l  - 3��� >   - 3��� l  - 1��� n   - 1��� 4   . 1��
� 
cobj� o   / 0�� 0 i  � o   - .�� 0 culturelist cultureList�  � m   1 2��      �  � k   6 s�� ��� r   6 D��� c   6 <��� n   6 :��� 4   7 :��
� 
cobj� o   8 9�� 0 i  � o   6 7�� 0 culturelist cultureList� m   : ;�
� 
ctxt� n      ��� 4   @ C�
�
�
 
ccel� m   A B��  Culture Name   � 4   < @�	�
�	 
cRQT� m   > ?�� � ��� I  E M���
� .FMPRFINDnull���    obj � 4   E I� 
� 
cwin  m   G H�� �  � � Z   N s�� l  N \�  I  N \����
�� .coredoexbool        obj  l  N X�� n   N X 1   T X��
�� 
vlue n   N T	
	 4   Q T��
�� 
ccel m   R S  Culture Name   
 1   N Q��
�� 
pCRW��  ��  �    r   _ o c   _ m n   _ k 1   g k��
�� 
vlue n   _ g 4   b g��
�� 
ccel m   c f  	Authority    1   _ b��
�� 
pCRW m   k l��
�� 
ctxt o      ���� 0 	authority  �  �  �  �  �  � R      ������
�� .ascrerr ****      � ****��  ��  � k    �  r    � c    � m    �       m   � ���
�� 
ctxt o      ���� 0 	authority     r   � �!"! [   � �#$# o   � ����� 0 
errorcount 
errorCount$ m   � ����� " o      ���� 0 
errorcount 
errorCount  %��% n  � �&'& I   � ���(���� 0 write_to_file  ( )*) l  � �+��+ b   � �,-, o   � ����� "0 outputdirectory outputDirectory- o   � ����� 0 errorlog errorLog��  * ./. b   � �010 b   � �232 b   � �454 b   � �676 b   � �898 b   � �:;: m   � �<<      ; o   � ����� 0 
errorcount 
errorCount9 m   � �== 	 : (   7 o   � ����� 0 
worknumber 
workNumber5 m   � �>> , &) Unable to get authority for culture    3 l  � �?��? n   � �@A@ 4   � ���B
�� 
cobjB o   � ����� 0 i  A o   � ����� 0 culturelist cultureList��  1 o   � ����� 0 newline newLine/ C��C m   � ���
�� boovtrue��  ��  '  f   � ���  � D��D r   � �EFE c   � �GHG b   � �IJI o   � ����� 0 authoritylist authorityListJ o   � ����� 0 	authority  H m   � ���
�� 
listF o      ���� 0 authoritylist authorityList��  � 0 i  � m    ���� � o    ���� 0 culturecount cultureCount�  �  � 4    ��K
�� 
cDB K o    ���� 0 irisculture irisCulture� m     �� L��L L   � �MM o   � ����� 0 authoritylist authorityList��  � NON l     ������  ��  O PQP l     ��R��  R K E getDateTimeString returns a string of the format YYYY-MM-DD HH:MM:SS   Q STS i    UVU I      ��W���� &0 getdatetimestring getDateTimeStringW X��X o      ���� 0 
dateobject 
dateObject��  ��  V k    �YY Z[Z q      \\ ��]�� 0 d  ] ��^�� 0 daystr dayStr^ ��_�� 0 m  _ ��`�� 0 monstr monStr` ��a�� 0 y  a ��b�� 0 secs  b ��c�� 0 hrstr hrStrc ��d�� 0 min  d ��e�� 0 minstr minStre ��f�� 0 secstr secStrf ������  0 datetimestring dateTimeString��  [ ghg r     iji n     klk 1    ��
�� 
day l o     ���� 0 
dateobject 
dateObjectj o      ���� 0 d  h mnm Z    op��qo l   	r��r A    	sts o    ���� 0 d  t m    ���� 
��  p r    uvu c    wxw b    yzy m    {{  0   z o    ���� 0 d  x m    ��
�� 
ctxtv o      ���� 0 daystr dayStr��  q r    |}| c    ~~ o    ���� 0 d   m    ��
�� 
ctxt} o      ���� 0 daystr dayStrn ��� r    !��� n    ��� m    ��
�� 
mnth� o    ���� 0 
dateobject 
dateObject� o      ���� 0 m  � ��� Z   " ������� l  " %���� =   " %��� o   " #���� 0 m  � m   # $��
�� 
jan ��  � r   ( +��� m   ( )��  01   � o      ���� 0 monstr monStr� ��� l  . 1���� =   . 1��� o   . /���� 0 m  � m   / 0��
�� 
feb ��  � ��� r   4 7��� m   4 5��  02   � o      ���� 0 monstr monStr� ��� l  : =���� =   : =��� o   : ;���� 0 m  � m   ; <��
�� 
mar ��  � ��� r   @ C��� m   @ A��  03   � o      ���� 0 monstr monStr� ��� l  F I���� =   F I��� o   F G���� 0 m  � m   G H��
�� 
apr ��  � ��� r   L O��� m   L M��  04   � o      ���� 0 monstr monStr� ��� l  R U���� =   R U��� o   R S���� 0 m  � m   S T��
�� 
may ��  � ��� r   X [��� m   X Y��  05   � o      ���� 0 monstr monStr� ��� l  ^ a���� =   ^ a��� o   ^ _���� 0 m  � m   _ `��
�� 
jun ��  � ��� r   d i��� m   d g��  06   � o      ���� 0 monstr monStr� ��� l  l q���� =   l q��� o   l m���� 0 m  � m   m p��
�� 
jul ��  � ��� r   t y��� m   t w��  07   � o      ���� 0 monstr monStr� ��� l  | ����� =   | ���� o   | }���� 0 m  � m   } ���
�� 
aug ��  � ��� r   � ���� m   � ���  08   � o      ���� 0 monstr monStr� ��� l  � ����� =   � ���� o   � ����� 0 m  � m   � ���
�� 
sep ��  � ��� r   � ���� m   � ���  09   � o      ���� 0 monstr monStr� ��� l  � ����� =   � ���� o   � ����� 0 m  � m   � ���
�� 
oct ��  � ��� r   � ���� m   � ���  10   � o      ���� 0 monstr monStr� ��� l  � ����� =   � ���� o   � ����� 0 m  � m   � ���
�� 
nov ��  � ��� r   � ���� m   � ���  11   � o      ���� 0 monstr monStr� ��� l  � ����� =   � ���� o   � ����� 0 m  � m   � ���
�� 
dec ��  � ��� r   � ���� m   � ���  12   � o      �~�~ 0 monstr monStr�  ��  � ��� r   � �   n   � � 1   � ��}
�} 
year o   � ��|�| 0 
dateobject 
dateObject o      �{�{ 0 y  �  r   � � n   � �	 1   � ��z
�z 
time	 o   � ��y�y 0 
dateobject 
dateObject o      �x�x 0 secs   

 Z   ��w l  � ��v @   � � o   � ��u�u 0 secs   m   � ��t�t�v   k   �  r   � � _   � � o   � ��s�s 0 secs   m   � ��r�r o      �q�q 0 h    r   � � `   � � o   � ��p�p 0 secs   m   � ��o�o o      �n�n 0 secs   �m Z   � !�l"  l  � �#�k# A   � �$%$ o   � ��j�j 0 h  % m   � ��i�i 
�k  ! r   �&'& c   �()( b   �*+* m   � �,,  0   + o   � �h�h 0 h  ) m  �g
�g 
ctxt' o      �f�f 0 hrstr hrStr�l  " r  -.- c  /0/ o  	�e�e 0 h  0 m  	
�d
�d 
ctxt. o      �c�c 0 hrstr hrStr�m  �w   r  121 m  33  00   2 o      �b�b 0 hrstr hrStr 454 Z  M67�a86 l 9�`9 @  :;: o  �_�_ 0 secs  ; m  �^�^ <�`  7 k  E<< =>= r  %?@? _  #ABA o  �]�] 0 secs  B m  "�\�\ <@ o      �[�[ 0 min  > CDC r  &-EFE `  &+GHG o  &'�Z�Z 0 secs  H m  '*�Y�Y <F o      �X�X 0 secs  D I�WI Z  .EJK�VLJ l .1M�UM A  .1NON o  ./�T�T 0 min  O m  /0�S�S 
�U  K r  4=PQP c  4;RSR b  49TUT m  47VV  0   U o  78�R�R 0 min  S m  9:�Q
�Q 
ctxtQ o      �P�P 0 minstr minStr�V  L r  @EWXW c  @CYZY o  @A�O�O 0 min  Z m  AB�N
�N 
ctxtX o      �M�M 0 minstr minStr�W  �a  8 r  HM[\[ m  HK]]  00   \ o      �L�L 0 minstr minStr5 ^_^ Z  Ne`a�Kb` l NQc�Jc A  NQded o  NO�I�I 0 secs  e m  OP�H�H 
�J  a r  T]fgf c  T[hih b  TYjkj m  TWll  0   k o  WX�G�G 0 secs  i m  YZ�F
�F 
ctxtg o      �E�E 0 secstr secStr�K  b r  `emnm c  `copo o  `a�D�D 0 secs  p m  ab�C
�C 
ctxtn o      �B�B 0 secstr secStr_ q�Aq r  f�rsr c  f�tut b  f�vwv b  f�xyx b  fz{z b  f}|}| b  fy~~ b  fw��� b  fs��� b  fq��� b  fm��� b  fk��� o  fg�@�@ 0 y  � m  gj��  -   � o  kl�?�? 0 monstr monStr� m  mp��  -   � o  qr�>�> 0 daystr dayStr� m  sv��       o  wx�=�= 0 hrstr hrStr} m  y|��  :   { o  }~�<�< 0 minstr minStry m  ���  :   w o  ���;�; 0 secstr secStru m  ���:
�: 
ctxts o      �9�9  0 datetimestring dateTimeString�A  T ��� l     �8�7�8  �7  � ��� l     �6��6  � � � getPeriodAuthority retrieves the authority value for each period specified in the list passed. A list of authority values is returned that correlates to the list of periods.   � ��� i    ��� I      �5��4�5 (0 getperiodauthority getPeriodAuthority� ��3� o      �2�2 0 
periodlist 
periodList�3  �4  � k     ��� ��� p      �� �1��1 0 
irisperiod 
irisPeriod� �0��0 "0 outputdirectory outputDirectory� �/��/ 0 newline newLine� �.��. 0 errorlog errorLog� �-��- 0 
errorcount 
errorCount� �,�+�, 0 
worknumber 
workNumber�+  � ��� q      �� �*��* 0 authoritylist authorityList� �)��) 0 periodcount periodCount� �(��( 0 i  � �'�&�' 0 	authority  �&  � ��� O     ���� O    ���� k    ��� ��� r    ��� c    ��� J    �%�%  � m    �$
�$ 
list� o      �#�# 0 authoritylist authorityList� ��� r    ��� I   �"��!
�" .corecnte****       ****� o    � �  0 
periodlist 
periodList�!  � o      �� 0 periodcount periodCount� ��� Y    ������� k   $ ��� ��� r   $ )��� c   $ '��� m   $ %��      � m   % &�
� 
ctxt� o      �� 0 	authority  � ��� Q   * ����� Z   - w����� l  - 3��� >   - 3��� l  - 1��� n   - 1��� 4   . 1��
� 
cobj� o   / 0�� 0 i  � o   - .�� 0 
periodlist 
periodList�  � m   1 2��      �  � k   6 s�� ��� r   6 D��� c   6 <��� n   6 :��� 4   7 :��
� 
cobj� o   8 9�� 0 i  � o   6 7�� 0 
periodlist 
periodList� m   : ;�
� 
ctxt� n      ��� 4   @ C��
� 
ccel� m   A B��  Period Name   � 4   < @��
� 
cRQT� m   > ?�� � ��� I  E M���

� .FMPRFINDnull���    obj � 4   E I�	�
�	 
cwin� m   G H�� �
  � ��� Z   N s����� l  N \��� I  N \���
� .coredoexbool        obj � l  N X��� n   N X��� 1   T X� 
�  
vlue� n   N T��� 4   Q T���
�� 
ccel� m   R S��  Period Name   � 1   N Q��
�� 
pCRW�  �  �  � r   _ o��� c   _ m��� n   _ k��� 1   g k��
�� 
vlue� n   _ g��� 4   b g���
�� 
ccel� m   c f��  	Authority   � 1   _ b��
�� 
pCRW� m   k l��
�� 
ctxt� o      ���� 0 	authority  �  �  �  �  �  � R      ������
�� .ascrerr ****      � ****��  ��  � k    ���    r    � c    � m    �       m   � ���
�� 
ctxt o      ���� 0 	authority    r   � �	
	 [   � � o   � ����� 0 
errorcount 
errorCount m   � ����� 
 o      ���� 0 
errorcount 
errorCount �� n  � � I   � ������� 0 write_to_file    l  � ��� b   � � o   � ����� "0 outputdirectory outputDirectory o   � ����� 0 errorlog errorLog��    b   � � b   � � b   � � b   � � b   � � !  b   � �"#" m   � �$$      # o   � ����� 0 
errorcount 
errorCount! m   � �%% 	 : (    o   � ����� 0 
worknumber 
workNumber m   � �&& + %) Unable to get authority for period     l  � �'��' n   � �()( 4   � ���*
�� 
cobj* o   � ����� 0 i  ) o   � ����� 0 
periodlist 
periodList��   o   � ����� 0 newline newLine +��+ m   � ���
�� boovtrue��  ��    f   � ���  � ,��, r   � �-.- c   � �/0/ b   � �121 o   � ����� 0 authoritylist authorityList2 o   � ����� 0 	authority  0 m   � ���
�� 
list. o      ���� 0 authoritylist authorityList��  � 0 i  � m    ���� � o    ���� 0 periodcount periodCount�  �  � 4    ��3
�� 
cDB 3 o    ���� 0 
irisperiod 
irisPeriod� m     �� 4��4 L   � �55 o   � ����� 0 authoritylist authorityList��  � 676 l     ������  ��  7 898 l     ��:��  : � � getSiteLongName retrieves a new concatenation for a site. This combines site, region and country without using any abbreviations.   9 ;<; i    =>= I      ��?���� "0 getsitelongname getSiteLongName? @��@ o      ����  0 concatsitename concatSiteName��  ��  > k    �AA BCB p      DD ��E�� 0 irissite irisSiteE ��F�� "0 outputdirectory outputDirectoryF ��G�� 0 newline newLineG ��H�� 0 errorlog errorLogH ��I�� 0 
errorcount 
errorCountI ������ 0 
worknumber 
workNumber��  C JKJ q      LL ��M�� 0 sitelongname siteLongNameM ������ 0 
regionlist 
regionList��  K NON r     PQP c     RSR m     TT      S m    ��
�� 
ctxtQ o      ���� 0 sitelongname siteLongNameO UVU Z   �WX����W l   	Y��Y >    	Z[Z o    ����  0 concatsitename concatSiteName[ m    \\      ��  X O   �]^] O   _`_ Q   ~abca k   Fdd efe r    %ghg c    iji o    ����  0 concatsitename concatSiteNamej m    ��
�� 
ctxth n      klk 4   ! $��m
�� 
ccelm m   " #nn  Concatenated Site Name   l 4    !��o
�� 
cRQTo m     ���� f pqp I  & .��r��
�� .FMPRFINDnull���    obj r 4   & *��s
�� 
cwins m   ( )���� ��  q tut Z   / [vw����v l  / ;x��x I  / ;��y��
�� .coredoexbool        obj y l  / 7z��z n   / 7{|{ 1   5 7��
�� 
vlue| n   / 5}~} 4   2 5��
�� 
ccel m   3 4��  	Site Name   ~ 1   / 2��
�� 
pCRW��  ��  ��  w k   > W�� ��� r   > L��� c   > J��� b   > H��� o   > ?���� 0 sitelongname siteLongName� n   ? G��� 1   E G��
�� 
vlue� n   ? E��� 4   B E���
�� 
ccel� m   C D��  	Site Name   � 1   ? B��
�� 
pCRW� m   H I��
�� 
ctxt� o      ���� 0 sitelongname siteLongName� ���� r   M W��� c   M U��� n  M S��� I   N S������� 0 	righttrim 	rightTrim� ���� o   N O���� 0 sitelongname siteLongName��  ��  �  f   M N� m   S T��
�� 
ctxt� o      ���� 0 sitelongname siteLongName��  ��  ��  u ��� Z   \ �������� l  \ j���� I  \ j�����
�� .coredoexbool        obj � l  \ f���� n   \ f��� 1   d f��
�� 
vlue� n   \ d��� 4   _ d���
�� 
ccel� m   ` c��  Region   � 1   \ _��
�� 
pCRW��  ��  ��  � k   m ��� ��� r   m }��� c   m {��� n   m w��� 1   u w��
�� 
vlue� n   m u��� 4   p u���
�� 
ccel� m   q t��  Region   � 1   m p��
�� 
pCRW� m   w z��
�� 
list� o      ���� 0 
regionlist 
regionList� ��� Z   ~ �������� l  ~ ����� >   ~ ���� n   ~ ���� 4    ����
�� 
cobj� m   � ����� � o   ~ ���� 0 
regionlist 
regionList� m   � ���      ��  � k   � ��� ��� Z   � �������� l  � ����� >   � ���� o   � ����� 0 sitelongname siteLongName� m   � ���      ��  � r   � ���� c   � ���� b   � ���� o   � ����� 0 sitelongname siteLongName� m   � ���  ,    � m   � ���
�� 
ctxt� o      ���� 0 sitelongname siteLongName��  ��  � ��� r   � ���� c   � ���� b   � ���� o   � ����� 0 sitelongname siteLongName� n   � ���� 4   � ����
�� 
cobj� m   � ����� � o   � ����� 0 
regionlist 
regionList� m   � ���
�� 
ctxt� o      ���� 0 sitelongname siteLongName� ��� r   � ���� c   � ���� n  � ���� I   � ��~��}�~ 0 	righttrim 	rightTrim� ��|� o   � ��{�{ 0 sitelongname siteLongName�|  �}  �  f   � �� m   � ��z
�z 
ctxt� o      �y�y 0 sitelongname siteLongName�  ��  ��  � ��x� Z   � ����w�v� l  � ���u� >   � ���� n   � ���� 4   � ��t�
�t 
cobj� m   � ��s�s � o   � ��r�r 0 
regionlist 
regionList� m   � ���      �u  � k   � ��� ��� Z   � ����q�p� l  � ���o� >   � ���� o   � ��n�n 0 sitelongname siteLongName� m   � ���      �o  � r   � ���� c   � ���� b   � ���� o   � ��m�m 0 sitelongname siteLongName� m   � ���  ,    � m   � ��l
�l 
ctxt� o      �k�k 0 sitelongname siteLongName�q  �p  � ��� r   � ���� c   � �   b   � � o   � ��j�j 0 sitelongname siteLongName n   � � 4   � ��i
�i 
cobj m   � ��h�h  o   � ��g�g 0 
regionlist 
regionList m   � ��f
�f 
ctxt� o      �e�e 0 sitelongname siteLongName� �d r   � �	 c   � �

 n  � � I   � ��c�b�c 0 	righttrim 	rightTrim �a o   � ��`�` 0 sitelongname siteLongName�a  �b    f   � � m   � ��_
�_ 
ctxt	 o      �^�^ 0 sitelongname siteLongName�d  �w  �v  �x  ��  ��  � �] Z   F�\�[ l  �Z I  �Y�X
�Y .coredoexbool        obj  l  
�W n   
 1  
�V
�V 
vlue n    4  �U
�U 
ccel m    Country    1   �T
�T 
pCRW�W  �X  �Z   k  B  Z  & �S�R l !�Q! >  "#" o  �P�P 0 sitelongname siteLongName# m  $$      �Q    r  "%&% c   '(' b  )*) o  �O�O 0 sitelongname siteLongName* m  ++  ,    ( m  �N
�N 
ctxt& o      �M�M 0 sitelongname siteLongName�S  �R   ,-, r  '7./. c  '5010 b  '3232 o  '(�L�L 0 sitelongname siteLongName3 n  (2454 1  02�K
�K 
vlue5 n  (0676 4  +0�J8
�J 
ccel8 m  ,/99  Country   7 1  (+�I
�I 
pCRW1 m  34�H
�H 
ctxt/ o      �G�G 0 sitelongname siteLongName- :�F: r  8B;<; c  8@=>= n 8>?@? I  9>�EA�D�E 0 	righttrim 	rightTrimA B�CB o  9:�B�B 0 sitelongname siteLongName�C  �D  @  f  89> m  >?�A
�A 
ctxt< o      �@�@ 0 sitelongname siteLongName�F  �\  �[  �]  b R      �?�>�=
�? .ascrerr ****      � ****�>  �=  c k  N~CC DED l NN�<F�<  F %  set siteLongName to "" as text   E GHG r  NWIJI [  NSKLK o  NQ�;�; 0 
errorcount 
errorCountL m  QR�:�: J o      �9�9 0 
errorcount 
errorCountH M�8M n X~NON I  Y~�7P�6�7 0 write_to_file  P QRQ l Y`S�5S b  Y`TUT o  Y\�4�4 "0 outputdirectory outputDirectoryU o  \_�3�3 0 errorlog errorLog�5  R VWV b  `yXYX b  `uZ[Z b  `s\]\ b  `o^_^ b  `k`a` b  `gbcb m  `cdd      c o  cf�2�2 0 
errorcount 
errorCounta m  gjee 	 : (   _ o  kn�1�1 0 
worknumber 
workNumber] m  orff , &) Unable to create long site name for    [ o  st�0�0  0 concatsitename concatSiteNameY o  ux�/�/ 0 newline newLineW g�.g m  yz�-
�- boovtrue�.  �6  O  f  XY�8  ` 4    �,h
�, 
cDB h o    �+�+ 0 irissite irisSite^ m    ���  ��  V i�*i L  ��jj o  ���)�) 0 sitelongname siteLongName�*  < klk l     �(�'�(  �'  l mnm l     �&o�&  o � � getSubjectAuthority retrieves the authority value for each subject term specified in the list passed. A list of authority values is returned that correlates to the list of subjects.   n pqp i    rsr I      �%t�$�% *0 getsubjectauthority getSubjectAuthorityt u�#u o      �"�" 0 subjectlist subjectList�#  �$  s k     �vv wxw p      yy �!z�! 0 irissubject irisSubjectz � {�  "0 outputdirectory outputDirectory{ �|� 0 newline newLine| �}� 0 errorlog errorLog} �~� 0 
errorcount 
errorCount~ ��� 0 
worknumber 
workNumber�  x � q      �� ��� 0 authoritylist authorityList� ��� 0 subjectcount subjectCount� ��� 0 i  � ��� 0 	authority  �  � ��� O     ���� O    ���� k    ��� ��� r    ��� c    ��� J    ��  � m    �
� 
list� o      �� 0 authoritylist authorityList� ��� r    ��� I   ���
� .corecnte****       ****� o    �� 0 subjectlist subjectList�  � o      �� 0 subjectcount subjectCount� ��� Y    ������� k   $ ��� ��� r   $ )��� c   $ '��� m   $ %��      � m   % &�
� 
ctxt� o      �
�
 0 	authority  � ��� Q   * ����� Z   - w���	�� l  - 3��� >   - 3��� l  - 1��� n   - 1��� 4   . 1��
� 
cobj� o   / 0�� 0 i  � o   - .�� 0 subjectlist subjectList�  � m   1 2��      �  � k   6 s�� ��� r   6 D��� c   6 <��� n   6 :��� 4   7 :��
� 
cobj� o   8 9�� 0 i  � o   6 7� �  0 subjectlist subjectList� m   : ;��
�� 
ctxt� n      ��� 4   @ C���
�� 
ccel� m   A B��  Subject Term   � 4   < @���
�� 
cRQT� m   > ?���� � ��� I  E M�����
�� .FMPRFINDnull���    obj � 4   E I���
�� 
cwin� m   G H���� ��  � ���� Z   N s������� l  N \���� I  N \�����
�� .coredoexbool        obj � l  N X���� n   N X��� 1   T X��
�� 
vlue� n   N T��� 4   Q T���
�� 
ccel� m   R S��  Subject Term   � 1   N Q��
�� 
pCRW��  ��  ��  � r   _ o��� c   _ m��� n   _ k��� 1   g k��
�� 
vlue� n   _ g��� 4   b g���
�� 
ccel� m   c f��  Subject Authority   � 1   _ b��
�� 
pCRW� m   k l��
�� 
ctxt� o      ���� 0 	authority  ��  ��  ��  �	  �  � R      ������
�� .ascrerr ****      � ****��  ��  � k    ��� ��� r    ���� c    ���� m    ���      � m   � ���
�� 
ctxt� o      ���� 0 	authority  � ��� r   � ���� [   � ���� o   � ����� 0 
errorcount 
errorCount� m   � ����� � o      ���� 0 
errorcount 
errorCount� ���� n  � ���� I   � �������� 0 write_to_file  � ��� l  � ����� b   � ���� o   � ����� "0 outputdirectory outputDirectory� o   � ����� 0 errorlog errorLog��  � ��� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� m   � �        � o   � ����� 0 
errorcount 
errorCount� m   � � 	 : (   � o   � ����� 0 
worknumber 
workNumber� m   � � 1 +) Unable to get authority for subject term    � l  � ��� n   � � 4   � ���
�� 
cobj o   � ����� 0 i   o   � ����� 0 subjectlist subjectList��  � o   � ����� 0 newline newLine� �� m   � ���
�� boovtrue��  ��  �  f   � ���  � �� r   � �	
	 c   � � b   � � o   � ����� 0 authoritylist authorityList o   � ����� 0 	authority   m   � ���
�� 
list
 o      ���� 0 authoritylist authorityList��  � 0 i  � m    ���� � o    ���� 0 subjectcount subjectCount�  �  � 4    ��
�� 
cDB  o    ���� 0 irissubject irisSubject� m     �� �� L   � � o   � ����� 0 authoritylist authorityList��  q  l     ������  ��    l     ����   � � getSubtypeAuthority retrieves the authority value for each subject subtype specified in the list passed. A list of authority values is returned that correlates to the list of subject subtypes.     i     I      ������ *0 getsubtypeauthority getSubtypeAuthority �� o      ���� 0 subtypelist subtypeList��  ��   k     �  p         ��!�� 0 irissubtype irisSubtype! ��"�� "0 outputdirectory outputDirectory" ��#�� 0 newline newLine# ��$�� 0 errorlog errorLog$ ��%�� 0 
errorcount 
errorCount% ������ 0 
worknumber 
workNumber��   &'& q      (( ��)�� 0 authoritylist authorityList) ��*�� 0 subtypecount subtypeCount* ��+�� 0 i  + ������ 0 	authority  ��  ' ,-, O     �./. O    �010 k    �22 343 r    565 c    787 J    ����  8 m    ��
�� 
list6 o      ���� 0 authoritylist authorityList4 9:9 r    ;<; I   ��=��
�� .corecnte****       ****= o    ���� 0 subtypelist subtypeList��  < o      ���� 0 subtypecount subtypeCount: >��> Y    �?��@A��? k   $ �BB CDC r   $ )EFE c   $ 'GHG m   $ %II      H m   % &��
�� 
ctxtF o      ���� 0 	authority  D JKJ Q   * �LMNL Z   - wOP����O l  - 3Q��Q >   - 3RSR l  - 1T��T n   - 1UVU 4   . 1��W
�� 
cobjW o   / 0���� 0 i  V o   - .���� 0 subtypelist subtypeList��  S m   1 2XX      ��  P k   6 sYY Z[Z r   6 D\]\ c   6 <^_^ n   6 :`a` 4   7 :��b
�� 
cobjb o   8 9���� 0 i  a o   6 7���� 0 subtypelist subtypeList_ m   : ;��
�� 
ctxt] n      cdc 4   @ C��e
�� 
ccele m   A Bff  Subtype   d 4   < @��g
�� 
cRQTg m   > ?���� [ hih I  E M��j��
�� .FMPRFINDnull���    obj j 4   E I��k
�� 
cwink m   G H���� ��  i l��l Z   N smn����m l  N \o��o I  N \��p��
�� .coredoexbool        obj p l  N Xq��q n   N Xrsr 1   T X��
�� 
vlues n   N Ttut 4   Q T��v
�� 
ccelv m   R Sww  Subtype   u 1   N Q��
�� 
pCRW��  ��  ��  n r   _ oxyx c   _ mz{z n   _ k|}| 1   g k��
�� 
vlue} n   _ g~~ 4   b g���
�� 
ccel� m   c f��  	Authority    1   _ b��
�� 
pCRW{ m   k l��
�� 
ctxty o      ���� 0 	authority  ��  ��  ��  ��  ��  M R      ������
�� .ascrerr ****      � ****��  ��  N k    ��� ��� r    ���� c    ���� m    ���      � m   � ���
�� 
ctxt� o      ���� 0 	authority  � ��� r   � ���� [   � ���� o   � ����� 0 
errorcount 
errorCount� m   � ����� � o      �� 0 
errorcount 
errorCount� ��~� n  � ���� I   � ��}��|�} 0 write_to_file  � ��� l  � ���{� b   � ���� o   � ��z�z "0 outputdirectory outputDirectory� o   � ��y�y 0 errorlog errorLog�{  � ��� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� b   � ���� m   � ���      � o   � ��x�x 0 
errorcount 
errorCount� m   � ��� 	 : (   � o   � ��w�w 0 
worknumber 
workNumber� m   � ��� , &) Unable to get authority for subtype    � l  � ���v� n   � ���� 4   � ��u�
�u 
cobj� o   � ��t�t 0 i  � o   � ��s�s 0 subtypelist subtypeList�v  � o   � ��r�r 0 newline newLine� ��q� m   � ��p
�p boovtrue�q  �|  �  f   � ��~  K ��o� r   � ���� c   � ���� b   � ���� o   � ��n�n 0 authoritylist authorityList� o   � ��m�m 0 	authority  � m   � ��l
�l 
list� o      �k�k 0 authoritylist authorityList�o  �� 0 i  @ m    �j�j A o    �i�i 0 subtypecount subtypeCount��  ��  1 4    �h�
�h 
cDB � o    �g�g 0 irissubtype irisSubtype/ m     �- ��f� L   � ��� o   � ��e�e 0 authoritylist authorityList�f   ��� l     �d�c�d  �c  � ��� l     �b��b  � � � getWorkTypeAuthority retrieves the authority value for each work type specified in the list passed. A list of authority values is returned that correlates to the list of work types.   � ��� i    ��� I      �a��`�a ,0 getworktypeauthority getWorkTypeAuthority� ��_� o      �^�^ 0 worktypelist workTypeList�_  �`  � k     ��� ��� p      �� �]��] 0 irisworktype irisWorkType� �\��\ "0 outputdirectory outputDirectory� �[��[ 0 newline newLine� �Z��Z 0 errorlog errorLog� �Y��Y 0 
errorcount 
errorCount� �X�W�X 0 
worknumber 
workNumber�W  � ��� q      �� �V��V 0 authoritylist authorityList� �U��U 0 worktypecount workTypeCount� �T��T 0 i  � �S�R�S 0 	authority  �R  � ��� O     ���� O    ���� k    ��� ��� r    ��� c    ��� J    �Q�Q  � m    �P
�P 
list� o      �O�O 0 authoritylist authorityList� ��� r    ��� I   �N��M
�N .corecnte****       ****� o    �L�L 0 worktypelist workTypeList�M  � o      �K�K 0 worktypecount workTypeCount� ��J� Y    ���I���H� k   $ ��� ��� r   $ )��� c   $ '��� m   $ %��      � m   % &�G
�G 
ctxt� o      �F�F 0 	authority  � ��� Q   * ����� Z   - w���E�D� l  - 3��C� >   - 3��� l  - 1��B� n   - 1��� 4   . 1�A�
�A 
cobj� o   / 0�@�@ 0 i  � o   - .�?�? 0 worktypelist workTypeList�B  � m   1 2��      �C  � k   6 s    r   6 D c   6 < n   6 : 4   7 :�>	
�> 
cobj	 o   8 9�=�= 0 i   o   6 7�<�< 0 worktypelist workTypeList m   : ;�;
�; 
ctxt n      

 4   @ C�:
�: 
ccel m   A B  	Work Type    4   < @�9
�9 
cRQT m   > ?�8�8   I  E M�7�6
�7 .FMPRFINDnull���    obj  4   E I�5
�5 
cwin m   G H�4�4 �6   �3 Z   N s�2�1 l  N \�0 I  N \�/�.
�/ .coredoexbool        obj  l  N X�- n   N X 1   T X�,
�, 
vlue n   N T 4   Q T�+
�+ 
ccel m   R S  	Work Type    1   N Q�*
�* 
pCRW�-  �.  �0   r   _ o  c   _ m!"! n   _ k#$# 1   g k�)
�) 
vlue$ n   _ g%&% 4   b g�('
�( 
ccel' m   c f((  Work Type Authority   & 1   _ b�'
�' 
pCRW" m   k l�&
�& 
ctxt  o      �%�% 0 	authority  �2  �1  �3  �E  �D  � R      �$�#�"
�$ .ascrerr ****      � ****�#  �"  � k    �)) *+* r    �,-, c    �./. m    �00      / m   � ��!
�! 
ctxt- o      � �  0 	authority  + 121 r   � �343 [   � �565 o   � ��� 0 
errorcount 
errorCount6 m   � ��� 4 o      �� 0 
errorcount 
errorCount2 7�7 n  � �898 I   � ��:�� 0 write_to_file  : ;<; l  � �=�= b   � �>?> o   � ��� "0 outputdirectory outputDirectory? o   � ��� 0 errorlog errorLog�  < @A@ b   � �BCB b   � �DED b   � �FGF b   � �HIH b   � �JKJ b   � �LML m   � �NN      M o   � ��� 0 
errorcount 
errorCountK m   � �OO 	 : (   I o   � ��� 0 
worknumber 
workNumberG m   � �PP . () Unable to get authority for work type    E l  � �Q�Q n   � �RSR 4   � ��T
� 
cobjT o   � ��� 0 i  S o   � ��� 0 worktypelist workTypeList�  C o   � ��� 0 newline newLineA U�U m   � ��
� boovtrue�  �  9  f   � ��  � V�V r   � �WXW c   � �YZY b   � �[\[ o   � ��� 0 authoritylist authorityList\ o   � ��� 0 	authority  Z m   � ��

�
 
listX o      �	�	 0 authoritylist authorityList�  �I 0 i  � m    �� � o    �� 0 worktypecount workTypeCount�H  �J  � 4    �]
� 
cDB ] o    �� 0 irisworktype irisWorkType� m     �� ^�^ L   � �__ o   � ��� 0 authoritylist authorityList�  � `a` l     ���  �  a bcb l     � d�   d 5 / joinby will join list of strings by delim char   c efe i     #ghg I      ��i���� 
0 joinby  i jkj o      ���� 0 somestrings  k l��l o      ���� 	0 delim  ��  ��  h k     *mm non Q     'pqrp k    ss tut r    vwv n   xyx 1    ��
�� 
txdly 1    ��
�� 
ascrw o      ���� 0 olddelim oldDelimu z{z r   	 |}| o   	 
���� 	0 delim  } n     ~~ 1    ��
�� 
txdl 1   
 ��
�� 
ascr{ ��� r    ��� c    ��� o    ���� 0 somestrings  � m    ��
�� 
TEXT� o      ���� 
0 retval  � ���� r    ��� o    ���� 0 olddelim oldDelim� n     ��� 1    ��
�� 
txdl� 1    ��
�� 
ascr��  q R      ������
�� .ascrerr ****      � ****��  ��  r r   " '��� o   " #���� 0 olddelim oldDelim� n     ��� 1   $ &��
�� 
txdl� 1   # $��
�� 
ascro ���� L   ( *�� o   ( )���� 
0 retval  ��  f ��� l     ������  ��  � ��� l     �����  � a [ listTrim takes a list and trims newline characters from the end of each string in the list   � ��� i   $ '��� I      ������� 0 listtrim listTrim� ���� o      ���� 0 lstvalue lstValue��  ��  � k     6�� ��� q      �� ����� 0 newlist newList� ����� 0 numitems numItems� ����� 0 i  � ������ 0 tempitem tempItem��  � ��� r     ��� c     ��� J     ����  � m    ��
�� 
list� o      ���� 0 newlist newList� ��� r    ��� I   �����
�� .corecnte****       ****� o    ���� 0 lstvalue lstValue��  � o      ���� 0 numitems numItems� ��� Y    3�������� k    .�� ��� r    !��� c    ��� n    ��� 4    ���
�� 
cobj� o    ���� 0 i  � o    ���� 0 lstvalue lstValue� m    ��
�� 
ctxt� o      ���� 0 tempitem tempItem� ���� r   " .��� c   " ,��� b   " *��� o   " #���� 0 newlist newList� n  # )��� I   $ )������� 0 	righttrim 	rightTrim� ���� o   $ %���� 0 tempitem tempItem��  ��  �  f   # $� m   * +��
�� 
list� o      ���� 0 newlist newList��  �� 0 i  � m    ���� � o    ���� 0 numitems numItems��  � ���� L   4 6�� o   4 5���� 0 newlist newList��  � ��� l     ������  ��  � ��� l     �����  � ] W rightTrim returns a string value with whitespace characters removed from the end of it   � ��� i   ( +��� I      ������� 0 	righttrim 	rightTrim� ���� o      ���� 0 strvalue strValue��  ��  � k     ��� ��� p      �� ������ 0 newline newLine��  � ��� q      �� ����� 0 strindex strIndex� ����� 0 lastchar lastChar� �����  0 carriagereturn carriageReturn� ������ 0 	spacechar 	spaceChar��  � ��� r     	��� c     ��� l    ���� I    �����
�� .sysontocTEXT       shor� m     ���� ��  ��  � m    ��
�� 
ctxt� o      ����  0 carriagereturn carriageReturn� ��� r   
 ��� c   
 ��� l  
 ���� I  
 �����
�� .sysontocTEXT       shor� m   
 ����  ��  ��  � m    ��
�� 
ctxt� o      ���� 0 	spacechar 	spaceChar� ��� r    ��� n    ��� 1    ��
�� 
leng� o    ���� 0 strvalue strValue� o      ���� 0 strindex strIndex� ���� Z    ������� =    ��� o    ���� 0 strindex strIndex� m    ����  � L     "�� o     !���� 0 strvalue strValue��  � k   % ��� ��� r   % +� � n   % ) 4   & )��
�� 
cha  o   ' (���� 0 strindex strIndex o   % &���� 0 strvalue strValue  o      ���� 0 lastchar lastChar�  V   , k k   D f 	
	 Z   D S���� l  D G�� ?   D G o   D E���� 0 strindex strIndex m   E F����  ��   r   J O \   J M o   J K���� 0 strindex strIndex m   K L����  o      ���� 0 strindex strIndex��  ��  
 �� Z   T f�� l  T W�� >   T W o   T U���� 0 strindex strIndex m   U V����  ��   r   Z ` n   Z ^ 4   [ ^��
�� 
cha  o   \ ]���� 0 strindex strIndex o   Z [���� 0 strvalue strValue o      ���� 0 lastchar lastChar��   r   c f !  m   c d""      ! o      ���� 0 lastchar lastChar��   G   0 C#$# G   0 ;%&% l  0 3'��' =   0 3()( o   0 1���� 0 lastchar lastChar) o   1 2���� 0 newline newLine��  & l  6 9*��* =   6 9+,+ o   6 7���� 0 lastchar lastChar, o   7 8����  0 carriagereturn carriageReturn��  $ l  > A-��- =   > A./. o   > ?���� 0 lastchar lastChar/ o   ? @�� 0 	spacechar 	spaceChar��   0�~0 Z   l �12�}31 l  l o4�|4 >   l o565 o   l m�{�{ 0 lastchar lastChar6 m   m n77      �|  2 L   r 88 n   r ~9:9 7  s }�z;<
�z 
ctxt; m   w y�y�y < o   z |�x�x 0 strindex strIndex: o   r s�w�w 0 strvalue strValue�}  3 L   � �== m   � �>>      �~  ��  � ?@? l     �v�u�v  �u  @ ABA l     �tC�t  C g a updateProjectOnWeb will pass status information in the URL via Safari that is used to update it.   B DED i   , /FGF I      �sH�r�s (0 updateprojectonweb updateProjectOnWebH IJI o      �q�q 0 projname projNameJ KLK o      �p�p 0 stepnum stepNumL MNM o      �o�o 0 	starttime 	startTimeN OPO o      �n�n 0 
finishtime 
finishTimeP Q�mQ o      �l�l 0 
errorcount 
errorCount�m  �r  G k     wRR STS p      UU �k�j�k .0 imageprojectstatusurl imageProjectStatusURL�j  T VWV q      XX �iY�i 0 urltext urlTextY �h�g�h 0 i  �g  W Z[Z r     	\]\ c     ^_^ b     `a` b     bcb o     �f�f .0 imageprojectstatusurl imageProjectStatusURLc m    dd  project=   a o    �e�e 0 projname projName_ m    �d
�d 
ctxt] o      �c�c 0 urltext urlText[ efe Z   
 %gh�b�ag G   
 iji l  
 k�`k =   
 lml o   
 �_�_ 0 stepnum stepNumm m    �^�^ �`  j l   n�]n =    opo o    �\�\ 0 stepnum stepNump m    �[�[ �]  h r    !qrq c    sts b    uvu b    wxw o    �Z�Z 0 urltext urlTextx m    yy  &step=   v o    �Y�Y 0 stepnum stepNumt m    �X
�X 
ctxtr o      �W�W 0 urltext urlText�b  �a  f z{z Z   & 9|}�V�U| l  & )~�T~ >   & )� o   & '�S�S 0 	starttime 	startTime� m   ' (��      �T  } r   , 5��� c   , 3��� b   , 1��� b   , /��� o   , -�R�R 0 urltext urlText� m   - .��  	&started=   � o   / 0�Q�Q 0 	starttime 	startTime� m   1 2�P
�P 
ctxt� o      �O�O 0 urltext urlText�V  �U  { ��� Z   : M���N�M� l  : =��L� >   : =��� o   : ;�K�K 0 
finishtime 
finishTime� m   ; <��      �L  � r   @ I��� c   @ G��� b   @ E��� b   @ C��� o   @ A�J�J 0 urltext urlText� m   A B��  
&finished=   � o   C D�I�I 0 
finishtime 
finishTime� m   E F�H
�H 
ctxt� o      �G�G 0 urltext urlText�N  �M  � ��� r   N W��� c   N U��� b   N S��� b   N Q��� o   N O�F�F 0 urltext urlText� m   O P��  &errorCount=   � o   Q R�E�E 0 
errorcount 
errorCount� m   S T�D
�D 
ctxt� o      �C�C 0 urltext urlText� ��B� O   X w��� k   \ v�� ��� I  \ a�A��@
�A .GURLGURLnull��� ��� TEXT� o   \ ]�?�? 0 urltext urlText�@  � ��� Y   b p��>���=� l  l l�<��<  � 4 . give the web browser some time before closing   �> 0 i  � m   e f�;�; � m   f g�:�: 
�=  � ��9� I  q v�8�7�6
�8 .aevtquitnull���    obj �7  �6  �9  � m   X Y���null     ߀��   
Safari.app��p   ��]m@�a�`��א    p(   )       �(�\�������sfri   alis    4  Main                       ��#H+     
Safari.app                                                       �Z�1k        ����  	                Applications    � #c      �1��         Main:Applications:Safari.app   
 S a f a r i . a p p  
  M a i n  Applications/Safari.app   / ��  �B  E ��� l     �5�4�5  �4  � ��� l     �3��3  � \ V Copied from http://bbs.applescript.net/viewtopic.php?t=5667&highlight=write+text+file   � ��� i   0 3��� I      �2��1�2 0 write_to_file  � ��� o      �0�0 0 the_file  � ��� o      �/�/ 0 
the_string  � ��.� o      �-�- 0 	appending  �.  �1  � k     R�� ��� r     ��� c     ��� o     �,�, 0 the_file  � m    �+
�+ 
TEXT� o      �*�* 0 the_file  � ��)� Q    R���� k   	 9�� ��� r   	 ��� I  	 �(��
�( .rdwropenshor       file� 4   	 �'�
�' 
file� o    �&�& 0 the_file  � �%��$
�% 
perm� m    �#
�# boovtrue�$  � o      �"�" 0 
write_file  � ��� Z   '���!� � =    ��� o    �� 0 	appending  � m    �
� boovfals� I   #���
� .rdwrseofnull���     ****� o    �� 0 
write_file  � ���
� 
set2� m    ��  �  �!  �   � ��� I  ( 3���
� .rdwrwritnull���     ****� o   ( )�� 0 
the_string  � ���
� 
refn� o   * +�� 0 
write_file  � ���
� 
wrat� m   , -�
� rdwreof � ���
� 
as  � m   . /�
� 
utf8�  � ��� I  4 9���
� .rdwrclosnull���     ****� o   4 5�� 0 
write_file  �  �  � R      ��
�	
� .ascrerr ****      � ****�
  �	  � Q   A R���� I  D I���
� .rdwrclosnull���     ****� o   D E�� 0 
write_file  �  � R      ���
� .ascrerr ****      � ****�  �  �  �)  � ��� l     �� �  �   � ��� l     �����  � ^ X Make sure that the pogo.lib dropbox is mounted. If not then prompt the user to connect.   � ��� l  � ����� r   � ���� I  � �������
�� .earslvolutxt  P ��� null��  ��  � o      ���� 0 
volumelist 
volumeList��  � ��� l  � ����� r   � ���� m   � ���
�� boovfals� o      ���� ,0 dropboxvolumemounted dropboxVolumeMounted��  � �	 � l  � �	��	 Y   � �	��		��	 Z   � �		����	 l  � �	��	 =   � �				 n   � �	
		
 4   � ���	
�� 
cobj	 o   � ����� 0 i  	 o   � ����� 0 
volumelist 
volumeList		 m   � �		  dropbox   ��  	 r   � �			 m   � ���
�� boovtrue	 o      ���� ,0 dropboxvolumemounted dropboxVolumeMounted��  ��  �� 0 i  	 m   � ����� 	 I  � ���	��
�� .corecnte****       ****	 o   � ����� 0 
volumelist 
volumeList��  ��  ��  	  			 l  � 	��	 Z   � 		����	 l  � �	��	 H   � �		 o   � ����� ,0 dropboxvolumemounted dropboxVolumeMounted��  	 I  � ���	��
�� .aevtmvolnull���     TEXT	 m   � �		 ) #smb://pogo.lib.virginia.edu/dropbox   ��  ��  ��  ��  	 			 l     ������  ��  	 			 l t	��	 t  t		 	 O  s	!	"	! k  r	#	# 	$	%	$ l ��	&��  	& 8 2Prompt for the desired project to export form IRIS   	% 	'	(	' I ��	)	*
�� .sysodlogaskr        TEXT	) m  	+	+  Enter the project name:   	* ��	,��
�� 
dtxt	, m  	-	-  backlog   ��  	( 	.	/	. r  $	0	1	0 n   	2	3	2 1   ��
�� 
ttxt	3 l 	4��	4 1  ��
�� 
rslt��  	1 o      ���� $0 projectnamevalue projectNameValue	/ 	5	6	5 r  %.	7	8	7 I %*������
�� .misccurdldt    ��� null��  ��  	8 o      ���� 0 	starttime 	startTime	6 	9	:	9 r  /=	;	<	; c  /9	=	>	= n /7	?	@	? I  07��	A���� &0 getdatetimestring getDateTimeString	A 	B��	B o  03���� 0 	starttime 	startTime��  ��  	@  f  /0	> m  78��
�� 
ctxt	< o      ���� 0 startdatetime startDateTime	: 	C	D	C n >P	E	F	E I  ?P��	G���� (0 updateprojectonweb updateProjectOnWeb	G 	H	I	H o  ?B���� $0 projectnamevalue projectNameValue	I 	J	K	J m  BC���� 	K 	L	M	L o  CF���� 0 startdatetime startDateTime	M 	N	O	N m  FI	P	P      	O 	Q��	Q m  IJ����  ��  ��  	F  f  >?	D 	R	S	R r  Q^	T	U	T c  QZ	V	W	V b  QX	X	Y	X o  QT���� $0 projectnamevalue projectNameValue	Y m  TW	Z	Z  .works   	W m  XY��
�� 
ctxt	U o      ����  0 outputfilename outputFilename	S 	[	\	[ l __������  ��  	\ 	]	^	] l __��	_��  	_ - ' Begin documenting this script's stats.   	^ 	`	a	` n _q	b	c	b I  `q��	d���� 0 write_to_file  	d 	e	f	e l `e	g��	g b  `e	h	i	h o  `a���� "0 outputdirectory outputDirectory	i o  ad���� 40 outputstatisticsfilename outputStatisticsFilename��  	f 	j	k	j b  el	l	m	l m  eh	n	n  Work Export - Step 1   	m o  hk���� 0 newline newLine	k 	o��	o m  lm��
�� boovfals��  ��  	c  f  _`	a 	p	q	p n r�	r	s	r I  s���	t���� 0 write_to_file  	t 	u	v	u l sx	w��	w b  sx	x	y	x o  st���� "0 outputdirectory outputDirectory	y o  tw���� 40 outputstatisticsfilename outputStatisticsFilename��  	v 	z	{	z b  x�	|	}	| b  x	~		~ m  x{	�	�  Start=   	 o  {~���� 0 	starttime 	startTime	} o  ����� 0 newline newLine	{ 	���	� m  ����
�� boovtrue��  ��  	s  f  rs	q 	�	�	� n ��	�	�	� I  ����	����� 0 write_to_file  	� 	�	�	� l ��	���	� b  ��	�	�	� o  ������ "0 outputdirectory outputDirectory	� o  ������ 40 outputstatisticsfilename outputStatisticsFilename��  	� 	�	�	� b  ��	�	�	� b  ��	�	�	� m  ��	�	�  Project Name=   	� o  ������ $0 projectnamevalue projectNameValue	� o  ������ 0 newline newLine	� 	���	� m  ����
�� boovtrue��  ��  	�  f  ��	� 	�	�	� l ��������  ��  	� 	�	�	� l ����	���  	� � z Generate a header line to the export file so it is available as a reference if anyone needs to manually examine the file.   	� 	�	�	� r  ��	�	�	� c  ��	�	�	� b  ��	�	�	� b  ��	�	�	� b  ��	�	�	� b  ��	�	�	� b  ��	�	�	� b  ��	�	�	� b  ��	�	�	� b  ��	�	�	� b  ��	�	�	� b  ��	�	�	� b  ��	�	�	� b  ��	�	�	� b  ��	�	�	� b  ��	�	�	� b  ��	�	�	� b  ��	�	�	� b  ��	�	�	� b  ��	�	�	� b  ��	�	�	� b  ��	�	�	� b  ��	�	�	� b  ��	�	�	� b  ��	�	�	� b  ��	�	�	� b  ��	�	�	� b  ��	�	�	� b  �	�	�	� b  �{	�	�	� b  �w	�	�	� b  �s	�	�	� b  �o	�	�	� b  �k	�	�	� b  �g	�	�	� b  �c	�	�	� b  �_	�	�	� b  �[	�	�	� b  �W	�	�	� b  �S	�	�	� b  �O	�	�	� b  �K	�	�	� b  �G	�	�	� b  �C	�	�	� b  �?	�	�	� b  �;	�	�	� b  �7	�	�	� b  �3	�	�	� b  �/	�	�	� b  �+	�	�	� b  �'	�
 	� b  �#


 b  �


 b  �


 b  �


 b  �
	


	 b  �


 b  �


 b  �


 b  �


 b  ��


 b  ��


 b  ��


 b  ��


 b  ��


 b  ��


 b  ��

 
 b  ��
!
"
! b  ��
#
$
# b  ��
%
&
% b  ��
'
(
' b  ��
)
*
) b  ��
+
,
+ b  ��
-
.
- b  ��
/
0
/ b  ��
1
2
1 b  ��
3
4
3 b  ��
5
6
5 b  ��
7
8
7 b  ��
9
:
9 b  ��
;
<
; b  ��
=
>
= b  ��
?
@
? m  ��
A
A  Work Number   
@ o  ������  0 fieldseparator fieldSeparator
> m  ��
B
B  Work PID   
< o  ������  0 fieldseparator fieldSeparator
: m  ��
C
C  Work Project Name   
8 o  ������  0 fieldseparator fieldSeparator
6 m  ��
D
D  Work Categories   
4 o  ������  0 fieldseparator fieldSeparator
2 m  ��
E
E  Work Subjects   
0 o  ������  0 fieldseparator fieldSeparator
. m  ��
F
F  Work Subject Authorities   
, o  ������  0 fieldseparator fieldSeparator
* m  ��
G
G  Work Subject Subtypes   
( o  ������  0 fieldseparator fieldSeparator
& m  ��
H
H &  Work Subject Subtype Authorities   
$ o  ������  0 fieldseparator fieldSeparator
" m  ��
I
I  Work Materials   
  o  ������  0 fieldseparator fieldSeparator
 m  ��
J
J  Work Century   
 o  ������  0 fieldseparator fieldSeparator
 m  ��
K
K  Work Start Year   
 o  ������  0 fieldseparator fieldSeparator
 m  ��
L
L  Work End Year   
 o  ������  0 fieldseparator fieldSeparator
 m  �
M
M  
Work Dates   
 o  ����  0 fieldseparator fieldSeparator
 m  

N
N  Work Era   
 o  ����  0 fieldseparator fieldSeparator

 m  
O
O  Work Country   
 o  ����  0 fieldseparator fieldSeparator
 m  
P
P  
Work Types   
 o  ����  0 fieldseparator fieldSeparator
 m  "
Q
Q  Work Type Authorities   
  o  #&����  0 fieldseparator fieldSeparator	� m  '*
R
R  Work Current Site   	� o  +.����  0 fieldseparator fieldSeparator	� m  /2
S
S  Work Cultures   	� o  36����  0 fieldseparator fieldSeparator	� m  7:
T
T  Work Culture Authorities   	� o  ;>����  0 fieldseparator fieldSeparator	� m  ?B
U
U  Work Periods   	� o  CF����  0 fieldseparator fieldSeparator	� m  GJ
V
V  Work Period Authorities   	� o  KN����  0 fieldseparator fieldSeparator	� m  OR
W
W  Work Techniques   	� o  SV����  0 fieldseparator fieldSeparator	� m  WZ
X
X  Work Repository Display   	� o  [^����  0 fieldseparator fieldSeparator	� m  _b
Y
Y  Work Repository Authority   	� o  cf����  0 fieldseparator fieldSeparator	� m  gj
Z
Z  Work Title Count   	� o  kn����  0 fieldseparator fieldSeparator	� m  or
[
[  Work Titles   	� o  sv����  0 fieldseparator fieldSeparator	� m  wz
\
\  Work Title Qualifiers   	� o  {~����  0 fieldseparator fieldSeparator	� m  �
]
]  Work Creator Count   	� o  ������  0 fieldseparator fieldSeparator	� m  ��
^
^  Work Creator Names   	� o  ������  0 fieldseparator fieldSeparator	� m  ��
_
_  Work Creator Qualifiers   	� o  ������  0 fieldseparator fieldSeparator	� m  ��
`
`  Work Creator Roles   	� o  ������  0 fieldseparator fieldSeparator	� m  ��
a
a  Work Creator Dates   	� o  ������  0 fieldseparator fieldSeparator	� m  ��
b
b  Work Creator Authority   	� o  ������  0 fieldseparator fieldSeparator	� m  ��
c
c  Work Former Site   	� o  ����  0 fieldseparator fieldSeparator	� m  ��
d
d  Work Locality   	� o  ���~�~  0 fieldseparator fieldSeparator	� m  ��
e
e  Work Dimensions   	� o  ���}�}  0 fieldseparator fieldSeparator	� m  ��
f
f  Work Repository No.   	� o  ���|�|  0 fieldseparator fieldSeparator	� m  ��
g
g  Work Collector   	� o  ���{�{  0 fieldseparator fieldSeparator	� m  ��
h
h  Work Cataloger's Notes   	� o  ���z�z  0 fieldseparator fieldSeparator	� m  ��
i
i  Work Export Date   	� o  ���y�y 0 newline newLine	� m  ���x
�x 
ctxt	� o      �w�w 0 
headerline 
headerLine	� 
j
k
j n ��
l
m
l I  ���v
n�u�v 0 write_to_file  
n 
o
p
o l ��
q�t
q b  ��
r
s
r o  ���s�s "0 outputdirectory outputDirectory
s o  ���r�r  0 outputfilename outputFilename�t  
p 
t
u
t o  ���q�q 0 
headerline 
headerLine
u 
v�p
v m  ���o
�o boovfals�p  �u  
m  f  ��
k 
w
x
w n �
y
z
y I  ��n
{�m�n 0 write_to_file  
{ 
|
}
| l �
~�l
~ b  �

�
 o  ���k�k "0 outputdirectory outputDirectory
� o  ��j�j 0 errorlog errorLog�l  
} 
�
�
� m  
�
�      
� 
��i
� m  �h
�h boovfals�i  �m  
z  f  ��
x 
�
�
� l �g�f�g  �f  
� 
�
�
� l �e
��e  
� b \ Initialize the work number file for use in retrieving image records with the step 2 script.   
� 
�
�
� n .
�
�
� I  .�d
��c�d 0 write_to_file  
� 
�
�
� l 
��b
� b  
�
�
� o  �a�a "0 outputdirectory outputDirectory
� o  �`�` $0 outputworknofile outputWorkNoFile�b  
� 
�
�
� b  )
�
�
� b  %
�
�
� b  !
�
�
� b  
�
�
� b  
�
�
� m  
�
�  Work No.   
� o  �_�_  0 fieldseparator fieldSeparator
� m  
�
�  Project Name   
� o   �^�^  0 fieldseparator fieldSeparator
� m  !$
�
�  Export Date   
� o  %(�]�] 0 newline newLine
� 
��\
� m  )*�[
�[ boovfals�\  �c  
�  f  
� 
�
�
� l //�Z�Y�Z  �Y  
� 
�
�
� l //�X
��X  
� B <open irisDirectory & irisCreation with password irisPassword   
� 
�
�
� I /8�W
��V
�W .GURLGURLnull��� ��� TEXT
� b  /4
�
�
� o  /0�U�U (0 irisremotelocation irisRemoteLocation
� o  03�T�T 0 iriscreation irisCreation�V  
� 
�
�
� r  9F
�
�
� l 9B
��S
� N  9B
�
� 4  9A�R
�
�R 
cDB 
� o  =@�Q�Q 0 iriscreation irisCreation�S  
� o      �P�P  0 iriscreationdb irisCreationDB
� 
�
�
� Z  Gi
�
��O�N
� = GP
�
�
� l GN
��M
� I GN�L
��K
�L .coredoexbool        obj 
� o  GJ�J�J  0 iriscreationdb irisCreationDB�K  �M  
� m  NO�I
�I boovfals
� k  Se
�
� 
�
�
� I Sb�H
��G
�H .sysodlogaskr        TEXT
� b  S^
�
�
� b  SZ
�
�
� m  SV
�
� % There is a problem finding the    
� o  VY�F�F 0 iriscreation irisCreation
� m  Z]
�
� F @ file. Click Cancel and resolve this, then run the script again.   �G  
� 
��E
� L  ce�D�D  �E  �O  �N  
� 
�
�
� l jj�C
��C  
� A ;open irisDirectory & irisCulture with password irisPassword   
� 
�
�
� I js�B
��A
�B .GURLGURLnull��� ��� TEXT
� b  jo
�
�
� o  jk�@�@ (0 irisremotelocation irisRemoteLocation
� o  kn�?�? 0 irisculture irisCulture�A  
� 
�
�
� r  t�
�
�
� l t}
��>
� N  t}
�
� 4  t|�=
�
�= 
cDB 
� o  x{�<�< 0 irisculture irisCulture�>  
� o      �;�; 0 irisculturedb irisCultureDB
� 
�
�
� Z  ��
�
��:�9
� = ��
�
�
� l ��
��8
� I ���7
��6
�7 .coredoexbool        obj 
� o  ���5�5 0 irisculturedb irisCultureDB�6  �8  
� m  ���4
�4 boovfals
� k  ��
�
� 
�
�
� I ���3
��2
�3 .sysodlogaskr        TEXT
� b  ��
�
�
� b  ��
�
�
� m  ��
�
� % There is a problem finding the    
� o  ���1�1 0 irisculture irisCulture
� m  ��
�
� F @ file. Click Cancel and resolve this, then run the script again.   �2  
� 
��0
� L  ���/�/  �0  �:  �9  
� 
�
�
� l ���.
��.  
� @ :open irisDirectory & irisPeriod with password irisPassword   
� 
�
�
� I ���-
��,
�- .GURLGURLnull��� ��� TEXT
� b  ��
�
�
� o  ���+�+ (0 irisremotelocation irisRemoteLocation
� o  ���*�* 0 
irisperiod 
irisPeriod�,  
� 
�
�
� r  ��
�
�
� l ��
��)
� N  ��
�
� 4  ���(
�
�( 
cDB 
� o  ���'�' 0 
irisperiod 
irisPeriod�)  
� o      �&�& 0 irisperioddb irisPeriodDB
� 
�
�
� Z  ��
�
��%�$
� = ��
�
�
� l ��
��#
� I ���" �!
�" .coredoexbool        obj   o  ��� �  0 irisperioddb irisPeriodDB�!  �#  
� m  ���
� boovfals
� k  ��  I ����
� .sysodlogaskr        TEXT b  �� b  �� m  ��		 % There is a problem finding the     o  ���� 0 
irisperiod 
irisPeriod m  ��

 F @ file. Click Cancel and resolve this, then run the script again.   �   � L  ����  �  �%  �$  
�  l ����   B <open irisDirectory & irisWorkType with password irisPassword     I ����
� .GURLGURLnull��� ��� TEXT b  �� o  ���� (0 irisremotelocation irisRemoteLocation o  ���� 0 irisworktype irisWorkType�    r  �� l ��� N  �� 4  ���
� 
cDB  o  ���� 0 irisworktype irisWorkType�   o      ��  0 irisworktypedb irisWorkTypeDB  Z  ��� = ��  l ��!�! I ���"�
� .coredoexbool        obj " o  ����  0 irisworktypedb irisWorkTypeDB�  �    m  ���

�
 boovfals k   ## $%$ I  �	&�
�	 .sysodlogaskr        TEXT& b   	'(' b   )*) m   ++ % There is a problem finding the    * o  �� 0 irisworktype irisWorkType( m  ,, F @ file. Click Cancel and resolve this, then run the script again.   �  % -�- L  ��  �  �  �   ./. l �0�  0 > 8open irisDirectory & irisSite with password irisPassword   / 121 I �3�
� .GURLGURLnull��� ��� TEXT3 b  454 o  �� (0 irisremotelocation irisRemoteLocation5 o  � �  0 irissite irisSite�  2 676 r  ,898 l (:��: N  (;; 4  '��<
�� 
cDB < o  #&���� 0 irissite irisSite��  9 o      ���� 0 
irissitedb 
irisSiteDB7 =>= Z  -O?@����? = -6ABA l -4C��C I -4��D��
�� .coredoexbool        obj D o  -0���� 0 
irissitedb 
irisSiteDB��  ��  B m  45��
�� boovfals@ k  9KEE FGF I 9H��H��
�� .sysodlogaskr        TEXTH b  9DIJI b  9@KLK m  9<MM % There is a problem finding the    L o  <?���� 0 irissite irisSiteJ m  @CNN F @ file. Click Cancel and resolve this, then run the script again.   ��  G O��O L  IK����  ��  ��  ��  > PQP l PP��R��  R D >open irisDirectory & irisRepository with password irisPassword   Q STS I PY��U��
�� .GURLGURLnull��� ��� TEXTU b  PUVWV o  PQ���� (0 irisremotelocation irisRemoteLocationW o  QT����  0 irisrepository irisRepository��  T XYX r  ZgZ[Z l Zc\��\ N  Zc]] 4  Zb��^
�� 
cDB ^ o  ^a����  0 irisrepository irisRepository��  [ o      ���� $0 irisrepositorydb irisRepositoryDBY _`_ Z  h�ab����a = hqcdc l hoe��e I ho��f��
�� .coredoexbool        obj f o  hk���� $0 irisrepositorydb irisRepositoryDB��  ��  d m  op��
�� boovfalsb k  t�gg hih I t���j��
�� .sysodlogaskr        TEXTj b  tklk b  t{mnm m  twoo % There is a problem finding the    n o  wz����  0 irisrepository irisRepositoryl m  {~pp F @ file. Click Cancel and resolve this, then run the script again.   ��  i q��q L  ������  ��  ��  ��  ` rsr l ����t��  t @ :open irisDirectory & irisTitles with password irisPassword   s uvu I ����w��
�� .GURLGURLnull��� ��� TEXTw b  ��xyx o  ������ (0 irisremotelocation irisRemoteLocationy o  ������ 0 
iristitles 
irisTitles��  v z{z r  ��|}| l ��~��~ N  �� 4  �����
�� 
cDB � o  ������ 0 
iristitles 
irisTitles��  } o      ���� 0 iristitlesdb irisTitlesDB{ ��� Z  ��������� = ����� l ������ I �������
�� .coredoexbool        obj � o  ������ 0 iristitlesdb irisTitlesDB��  ��  � m  ����
�� boovfals� k  ���� ��� I �������
�� .sysodlogaskr        TEXT� b  ����� b  ����� m  ���� % There is a problem finding the    � o  ������ 0 
iristitles 
irisTitles� m  ���� F @ file. Click Cancel and resolve this, then run the script again.   ��  � ���� L  ������  ��  ��  ��  � ��� l �������  � B <open irisDirectory & irisWCreator with password irisPassword   � ��� I �������
�� .GURLGURLnull��� ��� TEXT� b  ����� o  ������ (0 irisremotelocation irisRemoteLocation� o  ������ 0 iriswcreator irisWCreator��  � ��� r  ����� l ������ N  ���� 4  �����
�� 
cDB � o  ������ 0 iriswcreator irisWCreator��  � o      ����  0 iriswcreatordb irisWCreatorDB� ��� Z  ��������� = ����� l ������ I �������
�� .coredoexbool        obj � o  ������  0 iriswcreatordb irisWCreatorDB��  ��  � m  ����
�� boovfals� k  ���� ��� I �������
�� .sysodlogaskr        TEXT� b  ����� b  ����� m  ���� % There is a problem finding the    � o  ������ 0 iriswcreator irisWCreator� m  ���� F @ file. Click Cancel and resolve this, then run the script again.   ��  � ���� L  ������  ��  ��  ��  � ��� l �������  � A ;open irisDirectory & irisSubject with password irisPassword   � ��� I ������
�� .GURLGURLnull��� ��� TEXT� b  � ��� o  ������ (0 irisremotelocation irisRemoteLocation� o  ������ 0 irissubject irisSubject��  � ��� r  ��� l ���� N  �� 4  ���
�� 
cDB � o  	���� 0 irissubject irisSubject��  � o      ���� 0 irissubjectdb irisSubjectDB� ��� Z  5������� = ��� l ���� I �����
�� .coredoexbool        obj � o  ���� 0 irissubjectdb irisSubjectDB��  ��  � m  ��
�� boovfals� k  1�� ��� I .�����
�� .sysodlogaskr        TEXT� b  *��� b  &��� m  "�� % There is a problem finding the    � o  "%���� 0 irissubject irisSubject� m  &)�� F @ file. Click Cancel and resolve this, then run the script again.   ��  � ���� L  /1����  ��  ��  ��  � ��� l 66�����  � A ;open irisDirectory & irisSubtype with password irisPassword   � ��� I 6?�����
�� .GURLGURLnull��� ��� TEXT� b  6;��� o  67���� (0 irisremotelocation irisRemoteLocation� o  7:���� 0 irissubtype irisSubtype��  � ��� r  @M��� l @I���� N  @I�� 4  @H���
�� 
cDB � o  DG���� 0 irissubtype irisSubtype��  � o      ���� 0 irissubtypedb irisSubtypeDB� ��� Z  Np������� = NW��� l NU���� I NU�����
�� .coredoexbool        obj � o  NQ���� 0 irissubtypedb irisSubtypeDB��  ��  � m  UV��
�� boovfals� k  Zl�� ��� I Zi�����
�� .sysodlogaskr        TEXT� b  Ze��� b  Za��� m  Z]�� % There is a problem finding the    � o  ]`���� 0 irissubtype irisSubtype� m  ad�� F @ file. Click Cancel and resolve this, then run the script again.   ��  � ���� L  jl����  ��  ��  ��  � ��� l qq�����  � ? 9open irisDirectory & irisWorks with password irisPassword   � ��� I qx�����
�� .GURLGURLnull��� ��� TEXT� b  qt   o  qr���� (0 irisremotelocation irisRemoteLocation o  rs���� 0 	irisworks 	irisWorks��  �  r  y� l y��� N  y� 4  y��
�� 
cDB  o  }~�� 0 	irisworks 	irisWorks��   o      �~�~ 0 irisworksdb irisWorksDB 	
	 Z  ���}�| = �� l ���{ I ���z�y
�z .coredoexbool        obj  o  ���x�x 0 irisworksdb irisWorksDB�y  �{   m  ���w
�w boovfals k  ��  I ���v�u
�v .sysodlogaskr        TEXT b  �� b  �� m  �� % There is a problem finding the     o  ���t�t 0 	irisworks 	irisWorks m  �� F @ file. Click Cancel and resolve this, then run the script again.   �u   �s L  ���r�r  �s  �}  �|  
  l ���q�q   S M Identify the works to be exported and get their corresponding image records.      O  �!"! k  �## $%$ Z  �
&'�p(& l ��)�o) >  ��*+* o  ���n�n $0 projectnamevalue projectNameValue+ m  ��,,      �o  ' r  ��-.- c  ��/0/ l ��1�m1 6 ��232 n  ��454 1  ���l
�l 
ID  5 2  ���k
�k 
crow3 l ��6�j6 =  ��787 n  ��9:9 1  ���i
�i 
vlue: 4  ���h;
�h 
ccel; m  ��<<  Project Name   8 o  ���g�g $0 projectnamevalue projectNameValue�j  �m  0 m  ���f
�f 
list. o      �e�e 0 worklist workList�p  ( r  �
=>= c  �?@? l �A�dA 6 �BCB n  ��DED 1  ���c
�c 
ID  E 2  ���b
�b 
crowC l �F�aF >  �GHG n  ��IJI 1  ���`
�` 
vlueJ 4  ���_K
�_ 
ccelK m  ��LL  Approved   H m  � MM      �a  �d  @ m  �^
�^ 
list> o      �]�] 0 worklist workList% NON r  PQP I �\R�[
�\ .corecnte****       ****R o  �Z�Z 0 worklist workList�[  Q o      �Y�Y 0 	workcount 	workCountO STS l �X�W�X  �W  T UVU l �VW�V  W I C Loop through the works and identify approved works to be exported.   V XYX l �Z[Z Y  �\�U]^�T\ k  #�__ `a` l ##�Sb�S  b � ~display dialog "Processing work record " & workIndex & " of " & workCount buttons {"OK"} default button "OK" giving up after 1   a cdc r  #<efe l #8g�Rg N  #8hh 5  #7�Qi�P
�Q 
crowi l '3j�Oj c  '3klk n  '/mnm 4  */�No
�N 
cobjo o  -.�M�M 0 	workindex 	workIndexn o  '*�L�L 0 worklist workListl m  /2�K
�K 
long�O  
�P kfrmID  �R  f o      �J�J 0 
workrecord 
workRecordd pqp r  =Orsr n  =Ktut 1  GK�I
�I 
vlueu n  =Gvwv 4  @G�Hx
�H 
ccelx m  CFyy  Work No.   w o  =@�G�G 0 
workrecord 
workRecords o      �F�F 0 
worknumber 
workNumberq z{z l PP�E|�E  | 1 + Only export works that have been approved.   { }�D} l P�~~ Z  P����C�� l Pb��B� >  Pb��� l P^��A� n  P^��� 1  Z^�@
�@ 
vlue� n  PZ��� 4  SZ�?�
�? 
ccel� m  VY��  Approved   � o  PS�>�> 0 
workrecord 
workRecord�A  � m  ^a��      �B  � k  e��� ��� r  en��� [  ej��� o  eh�=�= $0 projectworkcount projectWorkCount� m  hi�<�< � o      �;�; $0 projectworkcount projectWorkCount� ��� r  o���� n  o}��� 1  y}�:
�: 
vlue� n  oy��� 4  ry�9�
�9 
ccel� m  ux��  Work No.   � o  or�8�8 0 
workrecord 
workRecord� o      �7�7 0 
worknumber 
workNumber� ��� r  ����� c  ����� n ����� I  ���6��5�6 0 	righttrim 	rightTrim� ��4� n  ����� 1  ���3
�3 
vlue� n  ����� 4  ���2�
�2 
ccel� m  ����  Project Name   � o  ���1�1 0 
workrecord 
workRecord�4  �5  �  f  ��� m  ���0
�0 
ctxt� o      �/�/ "0 workprojectname workProjectName� ��� r  ����� c  ����� n  ����� 1  ���.
�. 
vlue� n  ����� 4  ���-�
�- 
ccel� m  ����  Titles::Title   � o  ���,�, 0 
workrecord 
workRecord� m  ���+
�+ 
list� o      �*�* 0 	worktitle 	workTitle� ��� r  ����� n ����� I  ���)��(�) 0 listtrim listTrim� ��'� o  ���&�& 0 	worktitle 	workTitle�'  �(  �  f  ��� o      �%�% 0 	worktitle 	workTitle� ��� r  ����� c  ����� n  ����� 1  ���$
�$ 
vlue� n  ����� 4  ���#�
�# 
ccel� m  ����  Titles::Title Qualifier   � o  ���"�" 0 
workrecord 
workRecord� m  ���!
�! 
list� o      � �  (0 worktitlequalifier workTitleQualifier� ��� r  ����� n ����� I  ������ 0 listtrim listTrim� ��� o  ���� (0 worktitlequalifier workTitleQualifier�  �  �  f  ��� o      �� (0 worktitlequalifier workTitleQualifier� ��� r  ����� c  ����� n  ����� 1  ���
� 
vlue� n  ����� 4  ����
� 
ccel� m  ����  Category   � o  ���� 0 
workrecord 
workRecord� m  ���
� 
list� o      ��  0 workcategories workCategories� ��� r  ���� n ���� I  ����� 0 listtrim listTrim� ��� o  ����  0 workcategories workCategories�  �  �  f  ��� o      ��  0 workcategories workCategories� ��� r  ��� c  ��� n  ��� 1  �
� 
vlue� n  ��� 4  ��
� 
ccel� m  ��  Subjects   � o  �� 0 
workrecord 
workRecord� m  �
� 
list� o      �� 0 worksubjects workSubjects� ��� r  +��� n '��� I   '���
� 0 listtrim listTrim� ��	� o   #�� 0 worksubjects workSubjects�	  �
  �  f   � o      �� 0 worksubjects workSubjects� � � r  ,< c  ,8 n ,4 I  -4��� *0 getsubjectauthority getSubjectAuthority � o  -0�� 0 worksubjects workSubjects�  �    f  ,- m  47�
� 
list o      �� ,0 worksubjectauthority workSubjectAuthority  	
	 r  =I n =E I  >E� ���  0 listtrim listTrim �� o  >A���� ,0 worksubjectauthority workSubjectAuthority��  ��    f  => o      ���� ,0 worksubjectauthority workSubjectAuthority
  r  J` c  J\ n  JX 1  TX��
�� 
vlue n  JT 4  MT��
�� 
ccel m  PS  Subject Subtypes    o  JM���� 0 
workrecord 
workRecord m  X[��
�� 
list o      ���� *0 worksubjectsubtypes workSubjectSubtypes  r  am  n ai!"! I  bi��#���� 0 listtrim listTrim# $��$ o  be���� *0 worksubjectsubtypes workSubjectSubtypes��  ��  "  f  ab  o      ���� *0 worksubjectsubtypes workSubjectSubtypes %&% r  n~'(' c  nz)*) n nv+,+ I  ov��-���� *0 getsubtypeauthority getSubtypeAuthority- .��. o  or���� *0 worksubjectsubtypes workSubjectSubtypes��  ��  ,  f  no* m  vy��
�� 
list( o      ���� :0 worksubjectsubtypeauthority workSubjectSubtypeAuthority& /0/ r  �121 n �343 I  ����5���� 0 listtrim listTrim5 6��6 o  ������ :0 worksubjectsubtypeauthority workSubjectSubtypeAuthority��  ��  4  f  �2 o      ���� :0 worksubjectsubtypeauthority workSubjectSubtypeAuthority0 787 r  ��9:9 c  ��;<; n  ��=>= 1  ����
�� 
vlue> n  ��?@? 4  ����A
�� 
ccelA m  ��BB  	Materials   @ o  ������ 0 
workrecord 
workRecord< m  ����
�� 
list: o      ���� 0 workmaterials workMaterials8 CDC r  ��EFE n ��GHG I  ����I���� 0 listtrim listTrimI J��J o  ������ 0 workmaterials workMaterials��  ��  H  f  ��F o      ���� 0 workmaterials workMaterialsD KLK r  ��MNM c  ��OPO n  ��QRQ 1  ����
�� 
vlueR n  ��STS 4  ����U
�� 
ccelU m  ��VV  Century   T o  ������ 0 
workrecord 
workRecordP m  ����
�� 
listN o      ���� 0 workcentury workCenturyL WXW r  ��YZY n ��[\[ I  ����]���� 0 listtrim listTrim] ^��^ o  ������ 0 workcentury workCentury��  ��  \  f  ��Z o      ���� 0 workcentury workCenturyX _`_ r  ��aba c  ��cdc n ��efe I  ����g���� 0 	righttrim 	rightTrimg h��h n  ��iji 1  ����
�� 
vluej n  ��klk 4  ����m
�� 
ccelm m  ��nn  
Start Year   l o  ������ 0 
workrecord 
workRecord��  ��  f  f  ��d m  ����
�� 
ctxtb o      ���� 0 workstartyear workStartYear` opo r  �qrq c  �sts n �uvu I  ���w���� 0 	righttrim 	rightTrimw x��x n  ��yzy 1  ����
�� 
vluez n  ��{|{ 4  ����}
�� 
ccel} m  ��~~  End Year   | o  ������ 0 
workrecord 
workRecord��  ��  v  f  ��t m  ��
�� 
ctxtr o      ���� 0 workendyear workEndYearp � r  !��� c  ��� n ��� I  	������� 0 	righttrim 	rightTrim� ���� n  	��� 1  ��
�� 
vlue� n  	��� 4  ���
�� 
ccel� m  ��  
Work Dates   � o  	���� 0 
workrecord 
workRecord��  ��  �  f  	� m  ��
�� 
ctxt� o      ���� 0 	workdates 	workDates� ��� r  ";��� c  "7��� n "5��� I  #5������� 0 	righttrim 	rightTrim� ���� n  #1��� 1  -1��
�� 
vlue� n  #-��� 4  &-���
�� 
ccel� m  ),�� 	 Era   � o  #&���� 0 
workrecord 
workRecord��  ��  �  f  "#� m  56��
�� 
ctxt� o      ���� 0 workera workEra� ��� r  <R��� c  <N��� n  <J��� 1  FJ��
�� 
vlue� n  <F��� 4  ?F���
�� 
ccel� m  BE��  Country   � o  <?���� 0 
workrecord 
workRecord� m  JM��
�� 
list� o      ���� 0 workcountry workCountry� ��� r  S_��� n S[��� I  T[������� 0 listtrim listTrim� ���� o  TW���� 0 workcountry workCountry��  ��  �  f  ST� o      ���� 0 workcountry workCountry� ��� r  `v��� c  `r��� n  `n��� 1  jn��
�� 
vlue� n  `j��� 4  cj���
�� 
ccel� m  fi��  	Work Type   � o  `c���� 0 
workrecord 
workRecord� m  nq��
�� 
list� o      ���� 0 worktype workType� ��� r  w���� n w��� I  x������� 0 listtrim listTrim� ���� o  x{���� 0 worktype workType��  ��  �  f  wx� o      ���� 0 worktype workType� ��� r  ����� c  ����� n ����� I  ��������� ,0 getworktypeauthority getWorkTypeAuthority� ���� o  ������ 0 worktype workType��  ��  �  f  ��� m  ����
�� 
list� o      ���� &0 worktypeauthority workTypeAuthority� ��� r  ����� n ����� I  ��������� 0 listtrim listTrim� ���� o  ������ &0 worktypeauthority workTypeAuthority��  ��  �  f  ��� o      ���� &0 worktypeauthority workTypeAuthority� ��� Z  �������� l ������ I �������
�� .coredoexbool        obj � l ������ n  ����� 1  ����
�� 
vlue� n  ����� 4  �����
�� 
ccel� m  ����  Current Site   � o  ������ 0 
workrecord 
workRecord��  ��  ��  � k  ���� ��� r  ����� c  ����� n  ����� 1  ����
�� 
vlue� n  ����� 4  �����
�� 
ccel� m  ����  Current Site   � o  ������ 0 
workrecord 
workRecord� m  ����
�� 
ctxt� o      ����  0 workconcatsite workConcatSite� ���� r  ����� c  ����� n ����� I  ��������� "0 getsitelongname getSiteLongName� ���� o  ������  0 workconcatsite workConcatSite��  ��  �  f  ��� m  ����
�� 
ctxt� o      ���� "0 workcurrentsite workCurrentSite��  ��  � r  ����� c  ��� � m  ��        m  ���
� 
ctxt� o      �~�~ "0 workcurrentsite workCurrentSite�  Z  �	+�} l ���| I ���{�z
�{ .coredoexbool        obj  l ��	�y	 n  ��

 1  ���x
�x 
vlue n  �� 4  ���w
�w 
ccel m  ��  Former Site    o  ���v�v 0 
workrecord 
workRecord�y  �z  �|   k  �	  r  �	 c  �	 n  �	
 1  		
�u
�u 
vlue n  �	 4  �	�t
�t 
ccel m  		  Former Site    o  ���s�s 0 
workrecord 
workRecord m  	
	�r
�r 
ctxt o      �q�q  0 workconcatsite workConcatSite �p r  		 c  		 !  n 		"#" I  		�o$�n�o "0 getsitelongname getSiteLongName$ %�m% o  		�l�l  0 workconcatsite workConcatSite�m  �n  #  f  		! m  		�k
�k 
ctxt o      �j�j  0 workformersite workFormerSite�p  �}   r  	"	+&'& c  	"	'()( m  	"	%**      ) m  	%	&�i
�i 
ctxt' o      �h�h  0 workformersite workFormerSite +,+ r  	,	E-.- c  	,	A/0/ n 	,	?121 I  	-	?�g3�f�g 0 	righttrim 	rightTrim3 4�e4 n  	-	;565 1  	7	;�d
�d 
vlue6 n  	-	7787 4  	0	7�c9
�c 
ccel9 m  	3	6::  Locality   8 o  	-	0�b�b 0 
workrecord 
workRecord�e  �f  2  f  	,	-0 m  	?	@�a
�a 
ctxt. o      �`�` 0 worklocality workLocality, ;<; r  	F	_=>= c  	F	[?@? n 	F	YABA I  	G	Y�_C�^�_ 0 	righttrim 	rightTrimC D�]D n  	G	UEFE 1  	Q	U�\
�\ 
vlueF n  	G	QGHG 4  	J	Q�[I
�[ 
ccelI m  	M	PJJ  
Dimensions   H o  	G	J�Z�Z 0 
workrecord 
workRecord�]  �^  B  f  	F	G@ m  	Y	Z�Y
�Y 
ctxt> o      �X�X  0 workdimensions workDimensions< KLK r  	`	vMNM c  	`	rOPO n  	`	nQRQ 1  	j	n�W
�W 
vlueR n  	`	jSTS 4  	c	j�VU
�V 
ccelU m  	f	iVV  Culture   T o  	`	c�U�U 0 
workrecord 
workRecordP m  	n	q�T
�T 
listN o      �S�S 0 workculture workCultureL WXW r  	w	�YZY n 	w	[\[ I  	x	�R]�Q�R 0 listtrim listTrim] ^�P^ o  	x	{�O�O 0 workculture workCulture�P  �Q  \  f  	w	xZ o      �N�N 0 workculture workCultureX _`_ r  	�	�aba c  	�	�cdc n 	�	�efe I  	�	��Mg�L�M *0 getcultureauthority getCultureAuthorityg h�Kh o  	�	��J�J 0 workculture workCulture�K  �L  f  f  	�	�d m  	�	��I
�I 
listb o      �H�H ,0 workcultureauthority workCultureAuthority` iji r  	�	�klk n 	�	�mnm I  	�	��Go�F�G 0 listtrim listTrimo p�Ep o  	�	��D�D ,0 workcultureauthority workCultureAuthority�E  �F  n  f  	�	�l o      �C�C ,0 workcultureauthority workCultureAuthorityj qrq r  	�	�sts c  	�	�uvu n  	�	�wxw 1  	�	��B
�B 
vluex n  	�	�yzy 4  	�	��A{
�A 
ccel{ m  	�	�||  Period   z o  	�	��@�@ 0 
workrecord 
workRecordv m  	�	��?
�? 
listt o      �>�> 0 
workperiod 
workPeriodr }~} r  	�	�� n 	�	���� I  	�	��=��<�= 0 listtrim listTrim� ��;� o  	�	��:�: 0 
workperiod 
workPeriod�;  �<  �  f  	�	�� o      �9�9 0 
workperiod 
workPeriod~ ��� r  	�	���� c  	�	���� n 	�	���� I  	�	��8��7�8 (0 getperiodauthority getPeriodAuthority� ��6� o  	�	��5�5 0 
workperiod 
workPeriod�6  �7  �  f  	�	�� m  	�	��4
�4 
list� o      �3�3 *0 workperiodauthority workPeriodAuthority� ��� r  	�	���� n 	�	���� I  	�	��2��1�2 0 listtrim listTrim� ��0� o  	�	��/�/ *0 workperiodauthority workPeriodAuthority�0  �1  �  f  	�	�� o      �.�. *0 workperiodauthority workPeriodAuthority� ��� r  	�	���� c  	�	���� n  	�	���� 1  	�	��-
�- 
vlue� n  	�	���� 4  	�	��,�
�, 
ccel� m  	�	���  
Techniques   � o  	�	��+�+ 0 
workrecord 
workRecord� m  	�	��*
�* 
list� o      �)�)  0 worktechniques workTechniques� ��� r  	�
��� n 	�
��� I  	�
�(��'�( 0 listtrim listTrim� ��&� o  	�	��%�%  0 worktechniques workTechniques�&  �'  �  f  	�	�� o      �$�$  0 worktechniques workTechniques� ��� Z  
���#�� l 

��"� I 

�!�� 
�! .coredoexbool        obj � l 

��� n  

��� 1  

�
� 
vlue� n  

��� 4  

��
� 
ccel� m  

��  sRepository Display   � o  

�� 0 
workrecord 
workRecord�  �   �"  � k  
�� ��� l 

���  � ` Zset workRepositoryDisplay to cellValue of cell "sRepository Display" of workRecord as text   � ��� Z  

W����� l 

/��� I 

/���
� .coredoexbool        obj � l 

+��� n  

+��� 1  
'
+�
� 
vlue� n  

'��� 4  
 
'��
� 
ccel� m  
#
&�� ! Repository::Repository Name   � o  

 �� 0 
workrecord 
workRecord�  �  �  � r  
2
K��� c  
2
G��� n 
2
E��� I  
3
E���� 0 	righttrim 	rightTrim� ��� n  
3
A��� 1  
=
A�
� 
vlue� n  
3
=��� 4  
6
=��
� 
ccel� m  
9
<�� ! Repository::Repository Name   � o  
3
6�� 0 
workrecord 
workRecord�  �  �  f  
2
3� m  
E
F�
� 
ctxt� o      �� .0 workrepositorydisplay workRepositoryDisplay�  � r  
N
W��� c  
N
S��� m  
N
Q��      � m  
Q
R�

�
 
ctxt� o      �	�	 .0 workrepositorydisplay workRepositoryDisplay� ��� Z  
X
������ l 
X
j��� I 
X
j���
� .coredoexbool        obj � l 
X
f��� n  
X
f��� 1  
b
f�
� 
vlue� n  
X
b��� 4  
[
b��
� 
ccel� m  
^
a�� " Repository::Repository Place   � o  
X
[�� 0 
workrecord 
workRecord�  �  �  � k  
m
��� ��� r  
m
���� c  
m
}��� n  
m
{��� 1  
w
{� 
�  
vlue� n  
m
w��� 4  
p
w���
�� 
ccel� m  
s
v�� " Repository::Repository Place   � o  
m
p���� 0 
workrecord 
workRecord� m  
{
|��
�� 
ctxt� o      ���� 40 workrepositoryconcatsite workRepositoryConcatSite� ���� r  
�
���� c  
�
���� n 
�
���� I  
�
��� ���� "0 getsitelongname getSiteLongName  �� o  
�
����� 40 workrepositoryconcatsite workRepositoryConcatSite��  ��  �  f  
�
�� m  
�
���
�� 
ctxt� o      ���� *0 workrepositoryplace workRepositoryPlace��  �  � r  
�
� c  
�
� m  
�
�       m  
�
���
�� 
ctxt o      ���� *0 workrepositoryplace workRepositoryPlace�  Z  
�
�	
����	 l 
�
��� >  
�
� o  
�
����� .0 workrepositorydisplay workRepositoryDisplay m  
�
�      ��  
 r  
�
� c  
�
� b  
�
� o  
�
����� .0 workrepositorydisplay workRepositoryDisplay m  
�
�  ,     m  
�
���
�� 
ctxt o      ���� .0 workrepositorydisplay workRepositoryDisplay��  ��    r  
�
� c  
�
� b  
�
� o  
�
����� .0 workrepositorydisplay workRepositoryDisplay o  
�
����� *0 workrepositoryplace workRepositoryPlace m  
�
���
�� 
ctxt o      ���� .0 workrepositorydisplay workRepositoryDisplay �� Z  
� ��! l 
�
�"��" I 
�
���#��
�� .coredoexbool        obj # l 
�
�$��$ n  
�
�%&% 1  
�
���
�� 
vlue& n  
�
�'(' 4  
�
���)
�� 
ccel) m  
�
�** &  Repository::Repository Authority   ( o  
�
����� 0 
workrecord 
workRecord��  ��  ��    r  
�
�+,+ c  
�
�-.- n 
�
�/0/ I  
�
���1���� 0 	righttrim 	rightTrim1 2��2 n  
�
�343 1  
�
���
�� 
vlue4 n  
�
�565 4  
�
���7
�� 
ccel7 m  
�
�88 &  Repository::Repository Authority   6 o  
�
����� 0 
workrecord 
workRecord��  ��  0  f  
�
�. m  
�
���
�� 
ctxt, o      ���� 20 workrepositoryauthority workRepositoryAuthority��  ! r  
�9:9 c  
�
�;<; m  
�
�==      < m  
�
���
�� 
ctxt: o      ���� 20 workrepositoryauthority workRepositoryAuthority��  �#  � k  >> ?@? r  ABA c  	CDC m  EE      D m  ��
�� 
ctxtB o      ���� .0 workrepositorydisplay workRepositoryDisplay@ F��F r  GHG c  IJI m  KK      J m  ��
�� 
ctxtH o      ���� 20 workrepositoryauthority workRepositoryAuthority��  � LML r  1NON c  -PQP n +RSR I  +��T���� 0 	righttrim 	rightTrimT U��U n  'VWV 1  #'��
�� 
vlueW n  #XYX 4  #��Z
�� 
ccelZ m  "[[  Repository No.   Y o  ���� 0 
workrecord 
workRecord��  ��  S  f  Q m  +,��
�� 
ctxtO o      ���� ,0 workrepositorynumber workRepositoryNumberM \]\ r  2K^_^ c  2G`a` n 2Ebcb I  3E��d���� 0 	righttrim 	rightTrimd e��e n  3Afgf 1  =A��
�� 
vlueg n  3=hih 4  6=��j
�� 
ccelj m  9<kk  	Collector   i o  36���� 0 
workrecord 
workRecord��  ��  c  f  23a m  EF��
�� 
ctxt_ o      ���� 0 workcollector workCollector] lml r  Lenon c  Lapqp n L_rsr I  M_��t���� 0 	righttrim 	rightTrimt u��u n  M[vwv 1  W[��
�� 
vluew n  MWxyx 4  PW��z
�� 
ccelz m  SV{{  Cataloger's Notes   y o  MP���� 0 
workrecord 
workRecord��  ��  s  f  LMq m  _`��
�� 
ctxto o      ���� *0 workcatalogersnotes workCatalogersNotesm |}| r  fz~~ c  fv��� n  ft��� 1  pt��
�� 
vlue� n  fp��� 4  ip���
�� 
ccel� m  lo�� 	 PID   � o  fi���� 0 
workrecord 
workRecord� m  tu��
�� 
ctxt o      ���� 0 workpid workPID} ��� r  {���� c  {���� n  {���� 1  ����
�� 
vlue� n  {���� 4  ~����
�� 
ccel� m  ����  WCreator::Creator ID   � o  {~���� 0 
workrecord 
workRecord� m  ����
�� 
list� o      ���� 0 creatoridlist creatorIdList� ��� r  ����� c  ����� n  ����� 1  ����
�� 
vlue� n  ����� 4  �����
�� 
ccel� m  ����  WCreator::Creator Name   � o  ������ 0 
workrecord 
workRecord� m  ����
�� 
list� o      ���� "0 workcreatorname workCreatorName� ��� r  ����� n ����� I  ��������� 0 listtrim listTrim� ���� o  ������ "0 workcreatorname workCreatorName��  ��  �  f  ��� o      ���� "0 workcreatorname workCreatorName� ��� r  ����� c  ����� n  ����� 1  ����
�� 
vlue� n  ����� 4  �����
�� 
ccel� m  ���� ! WCreator::Creator Qualifier   � o  ������ 0 
workrecord 
workRecord� m  ����
�� 
list� o      ���� ,0 workcreatorqualifier workCreatorQualifier� ��� r  ����� n ����� I  ��������� 0 listtrim listTrim� ���� o  ������ ,0 workcreatorqualifier workCreatorQualifier��  ��  �  f  ��� o      ���� ,0 workcreatorqualifier workCreatorQualifier� ��� r  ����� c  ����� n  ����� 1  ����
�� 
vlue� n  ����� 4  �����
�� 
ccel� m  ����  WCreator::Creator Role   � o  ������ 0 
workrecord 
workRecord� m  ����
�� 
list� o      ���� "0 workcreatorrole workCreatorRole� ��� r  ����� n ����� I  ��������� 0 listtrim listTrim� ���� o  ������ "0 workcreatorrole workCreatorRole��  ��  �  f  ��� o      ���� "0 workcreatorrole workCreatorRole� ��� r  ���� c  ���� n  ���� 1  ��
�� 
vlue� n  ���� 4  ���
�� 
ccel� m  ��  WCreator::Creator Dates   � o  ����� 0 
workrecord 
workRecord� m  ��
�� 
list� o      ���� $0 workcreatordates workCreatorDates� ��� r  !��� n ��� I  ������� 0 listtrim listTrim� ���� o  ���� $0 workcreatordates workCreatorDates��  ��  �  f  � o      ���� $0 workcreatordates workCreatorDates� ��� r  "2��� c  ".��� n "*��� I  #*������� *0 getcreatorauthority getCreatorAuthority� ���� o  #&���� 0 creatoridlist creatorIdList��  ��  �  f  "#� m  *-��
�� 
list� o      ���� ,0 workcreatorauthority workCreatorAuthority� ��� r  3?��� n 3;��� I  4;���~� 0 listtrim listTrim� ��}� o  47�|�| ,0 workcreatorauthority workCreatorAuthority�}  �~  �  f  34� o      �{�{ ,0 workcreatorauthority workCreatorAuthority� ��� r  @R��� n  @N��� 1  JN�z
�z 
vlue� n  @J��� 4  CJ�y�
�y 
ccel� m  FI��  Export Date   � o  @C�x�x 0 
workrecord 
workRecord� o      �w�w  0 workexportdate workExportDate�    r  S^ I SZ�v�u
�v .corecnte****       **** o  SV�t�t 0 	worktitle 	workTitle�u   o      �s�s  0 worktitlecount workTitleCount  r  _j I _f�r	�q
�r .corecnte****       ****	 o  _b�p�p 0 creatoridlist creatorIdList�q   o      �o�o $0 workcreatorcount workCreatorCount 

 r  k\ c  kX b  kV b  kR b  kN b  kJ b  kF b  kB b  k> b  k: b  k6 !  b  k2"#" b  k.$%$ b  k*&'& b  k&()( b  k"*+* b  k,-, b  k./. b  k010 b  k232 b  k�454 b  k�676 b  k�898 b  k�:;: b  k�<=< b  k�>?> b  k�@A@ b  k�BCB b  k�DED b  k�FGF b  k�HIH b  k�JKJ b  k�LML b  k�NON b  k�PQP b  k�RSR b  k�TUT b  k�VWV b  k�XYX b  k�Z[Z b  k~\]\ b  kr^_^ b  kn`a` b  kbbcb b  k^ded b  kRfgf b  kNhih b  kBjkj b  k>lml b  k:non b  k6pqp b  k*rsr b  k&tut b  kvwv b  kxyx b  kz{z b  k|}| b  k
~~ b  k��� b  k��� b  k���� b  k���� b  k���� b  k���� b  k���� b  k���� b  k���� b  k���� b  k���� b  k���� b  k���� b  k���� b  k���� b  k���� b  k���� b  k���� b  k���� b  k���� b  k~��� b  kz��� b  kv��� b  kr��� o  kn�n�n 0 
worknumber 
workNumber� o  nq�m�m  0 fieldseparator fieldSeparator� o  ru�l�l 0 workpid workPID� o  vy�k�k  0 fieldseparator fieldSeparator� o  z}�j�j "0 workprojectname workProjectName� o  ~��i�i  0 fieldseparator fieldSeparator� n ����� I  ���h��g�h 
0 joinby  � ��� o  ���f�f  0 workcategories workCategories� ��e� o  ���d�d  0 valueseparator valueSeparator�e  �g  �  f  ��� o  ���c�c  0 fieldseparator fieldSeparator� n ����� I  ���b��a�b 
0 joinby  � ��� o  ���`�` 0 worksubjects workSubjects� ��_� o  ���^�^  0 valueseparator valueSeparator�_  �a  �  f  ��� o  ���]�]  0 fieldseparator fieldSeparator� n ����� I  ���\��[�\ 
0 joinby  � ��� o  ���Z�Z ,0 worksubjectauthority workSubjectAuthority� ��Y� o  ���X�X  0 valueseparator valueSeparator�Y  �[  �  f  ��� o  ���W�W  0 fieldseparator fieldSeparator� n ����� I  ���V��U�V 
0 joinby  � ��� o  ���T�T *0 worksubjectsubtypes workSubjectSubtypes� ��S� o  ���R�R  0 valueseparator valueSeparator�S  �U  �  f  ��� o  ���Q�Q  0 fieldseparator fieldSeparator� n ����� I  ���P��O�P 
0 joinby  � ��� o  ���N�N :0 worksubjectsubtypeauthority workSubjectSubtypeAuthority� ��M� o  ���L�L  0 valueseparator valueSeparator�M  �O  �  f  ��� o  ���K�K  0 fieldseparator fieldSeparator� n ����� I  ���J��I�J 
0 joinby  � ��� o  ���H�H 0 workmaterials workMaterials� ��G� o  ���F�F  0 valueseparator valueSeparator�G  �I  �  f  ��� o  ���E�E  0 fieldseparator fieldSeparator� n ����� I  ���D��C�D 
0 joinby  � ��� o  ���B�B 0 workcentury workCentury� ��A� o  ���@�@  0 valueseparator valueSeparator�A  �C  �  f  ��� o  ���?�?  0 fieldseparator fieldSeparator� o  ���>�> 0 workstartyear workStartYear� o  ���=�=  0 fieldseparator fieldSeparator� o  ���<�< 0 workendyear workEndYear� o  ��;�;  0 fieldseparator fieldSeparator� o  �:�: 0 	workdates 	workDates o  	�9�9  0 fieldseparator fieldSeparator} o  
�8�8 0 workera workEra{ o  �7�7  0 fieldseparator fieldSeparatory o  �6�6 0 workcountry workCountryw o  �5�5  0 fieldseparator fieldSeparatoru n %��� I  %�4��3�4 
0 joinby  � ��� o  �2�2 0 worktype workType� ��1� o  !�0�0  0 valueseparator valueSeparator�1  �3  �  f  s o  &)�/�/  0 fieldseparator fieldSeparatorq n *5��� I  +5�.��-�. 
0 joinby  � ��� o  +.�,�, &0 worktypeauthority workTypeAuthority� ��+� o  .1�*�*  0 valueseparator valueSeparator�+  �-  �  f  *+o o  69�)�)  0 fieldseparator fieldSeparatorm o  :=�(�( "0 workcurrentsite workCurrentSitek o  >A�'�'  0 fieldseparator fieldSeparatori n BM��� I  CM�&��%�& 
0 joinby  � ��� o  CF�$�$ 0 workculture workCulture� ��#� o  FI�"�"  0 valueseparator valueSeparator�#  �%  �  f  BCg o  NQ�!�!  0 fieldseparator fieldSeparatore n R]��� I  S]� ���  
0 joinby  � ��� o  SV�� ,0 workcultureauthority workCultureAuthority� ��� o  VY��  0 valueseparator valueSeparator�  �  �  f  RSc o  ^a��  0 fieldseparator fieldSeparatora n bm��� I  cm���� 
0 joinby  � ��� o  cf�� 0 
workperiod 
workPeriod� ��� o  fi��  0 valueseparator valueSeparator�  �  �  f  bc_ o  nq��  0 fieldseparator fieldSeparator] n r}��� I  s}���� 
0 joinby  � ��� o  sv�� *0 workperiodauthority workPeriodAuthority� ��� o  vy��  0 valueseparator valueSeparator�  �  �  f  rs[ o  ~���  0 fieldseparator fieldSeparatorY n ����� I  ��� �� 
0 joinby     o  ����  0 worktechniques workTechniques � o  ���
�
  0 valueseparator valueSeparator�  �  �  f  ��W o  ���	�	  0 fieldseparator fieldSeparatorU o  ���� .0 workrepositorydisplay workRepositoryDisplayS o  ����  0 fieldseparator fieldSeparatorQ o  ���� 20 workrepositoryauthority workRepositoryAuthorityO o  ����  0 fieldseparator fieldSeparatorM o  ����  0 worktitlecount workTitleCountK o  ����  0 fieldseparator fieldSeparatorI n �� I  ����� 
0 joinby    o  ��� �  0 	worktitle 	workTitle 	��	 o  ������  0 valueseparator valueSeparator��  �    f  ��G o  ������  0 fieldseparator fieldSeparatorE n ��

 I  �������� 
0 joinby    o  ������ (0 worktitlequalifier workTitleQualifier �� o  ������  0 valueseparator valueSeparator��  ��    f  ��C o  ������  0 fieldseparator fieldSeparatorA o  ������ $0 workcreatorcount workCreatorCount? o  ������  0 fieldseparator fieldSeparator= n �� I  �������� 
0 joinby    o  ������ "0 workcreatorname workCreatorName �� o  ������  0 valueseparator valueSeparator��  ��    f  ��; o  ������  0 fieldseparator fieldSeparator9 n �� I  �������� 
0 joinby    o  ������ ,0 workcreatorqualifier workCreatorQualifier �� o  ������  0 valueseparator valueSeparator��  ��    f  ��7 o  ������  0 fieldseparator fieldSeparator5 n �� I  �������� 
0 joinby     o  ������ "0 workcreatorrole workCreatorRole  !��! o  ������  0 valueseparator valueSeparator��  ��    f  ��3 o  �����  0 fieldseparator fieldSeparator1 n "#" I  ��$���� 
0 joinby  $ %&% o  ���� $0 workcreatordates workCreatorDates& '��' o  	����  0 valueseparator valueSeparator��  ��  #  f  / o  ����  0 fieldseparator fieldSeparator- n ()( I  ��*���� 
0 joinby  * +,+ o  ���� ,0 workcreatorauthority workCreatorAuthority, -��- o  ����  0 valueseparator valueSeparator��  ��  )  f  + o  !����  0 fieldseparator fieldSeparator) o  "%����  0 workformersite workFormerSite' o  &)����  0 fieldseparator fieldSeparator% o  *-���� 0 worklocality workLocality# o  .1����  0 fieldseparator fieldSeparator! o  25����  0 workdimensions workDimensions o  69����  0 fieldseparator fieldSeparator o  :=���� ,0 workrepositorynumber workRepositoryNumber o  >A����  0 fieldseparator fieldSeparator o  BE���� 0 workcollector workCollector o  FI����  0 fieldseparator fieldSeparator o  JM���� *0 workcatalogersnotes workCatalogersNotes o  NQ����  0 fieldseparator fieldSeparator o  RU����  0 workexportdate workExportDate m  VW��
�� 
ctxt o      ���� (0 workmetadatastring workMetadataString ./. n ]o010 I  ^o��2���� 0 write_to_file  2 343 l ^c5��5 b  ^c676 o  ^_���� "0 outputdirectory outputDirectory7 o  _b����  0 outputfilename outputFilename��  4 898 b  cj:;: o  cf���� (0 workmetadatastring workMetadataString; o  fi���� 0 newline newLine9 <��< m  jk��
�� boovtrue��  ��  1  f  ]^/ =>= l pp��?��  ? \ V Identify that this work was exported for the next script that gets image/source data.   > @��@ n p�ABA I  q���C���� 0 write_to_file  C DED l qvF��F b  qvGHG o  qr���� "0 outputdirectory outputDirectoryH o  ru���� $0 outputworknofile outputWorkNoFile��  E IJI b  v�KLK b  v�MNM b  v�OPO b  v�QRQ b  v�STS b  v}UVU m  vyWW      V o  y|���� 0 
worknumber 
workNumberT o  }�����  0 fieldseparator fieldSeparatorR o  ������ "0 workprojectname workProjectNameP o  ������  0 fieldseparator fieldSeparatorN o  ������  0 workexportdate workExportDateL o  ������ 0 newline newLineJ X��X m  ����
�� boovtrue��  ��  B  f  pq��  �C  � k  ��YY Z[Z r  ��\]\ n  ��^_^ 1  ����
�� 
vlue_ n  ��`a` 4  ����b
�� 
ccelb m  ��cc  Work No.   a o  ������ 0 
workrecord 
workRecord] o      ���� 0 
worknumber 
workNumber[ d��d n ��efe I  ����g���� 0 write_to_file  g hih l ��j��j b  ��klk o  ������ "0 outputdirectory outputDirectoryl o  ������ 40 outputstatisticsfilename outputStatisticsFilename��  i mnm b  ��opo b  ��qrq b  ��sts m  ��uu  Warning: work number    t o  ������ 0 
worknumber 
workNumberr m  ��vv ( " is not approved for this project!   p o  ������ 0 newline newLinen w��w m  ����
�� boovtrue��  ��  f  f  ����     work record approved   �D  �U 0 	workindex 	workIndex] m  ���� ^ o  ���� 0 	workcount 	workCount�T  [   for each work   Y xyx n ��z{z I  ����|���� 0 write_to_file  | }~} l ���� b  ����� o  ������ "0 outputdirectory outputDirectory� o  ������ 40 outputstatisticsfilename outputStatisticsFilename��  ~ ��� b  ����� b  ����� m  ����  Project Work Count=   � o  ������ 0 	workcount 	workCount� o  ������ 0 newline newLine� ���� m  ����
�� boovtrue��  ��  {  f  ��y ��� n ����� I  ��������� 0 write_to_file  � ��� l ������ b  ����� o  ������ "0 outputdirectory outputDirectory� o  ������ 40 outputstatisticsfilename outputStatisticsFilename��  � ��� b  ����� b  ����� m  ���� " Approved Project Work Count=   � o  ������ $0 projectworkcount projectWorkCount� o  ������ 0 newline newLine� ���� m  ����
�� boovtrue��  ��  �  f  ��� ���� n ���� I  �������� 0 write_to_file  � ��� l � ���� b  � ��� o  ������ "0 outputdirectory outputDirectory� o  ������ 40 outputstatisticsfilename outputStatisticsFilename��  � ��� b   ��� b   ��� m   ��  Error Count=   � o  ���� 0 
errorcount 
errorCount� o  
���� 0 newline newLine� ���� m  ��
�� boovtrue��  ��  �  f  ����  " 4  �����
�� 
cDB � o  ������ 0 	irisworks 	irisWorks  ��� r  ��� I �����
�� .misccurdldt    ��� null��  �  � o      �~�~ 0 endtime endTime� ��� n 2��� I  2�}��|�} 0 write_to_file  � ��� l "��{� b  "��� o  �z�z "0 outputdirectory outputDirectory� o  !�y�y 40 outputstatisticsfilename outputStatisticsFilename�{  � ��� b  "-��� b  ")��� m  "%�� 
 End=   � o  %(�x�x 0 endtime endTime� o  ),�w�w 0 newline newLine� ��v� m  -.�u
�u boovtrue�v  �|  �  f  � ��� r  3A��� c  3=��� n 3;��� I  4;�t��s�t &0 getdatetimestring getDateTimeString� ��r� o  47�q�q 0 endtime endTime�r  �s  �  f  34� m  ;<�p
�p 
ctxt� o      �o�o 0 enddatetime endDateTime� ��� n BV��� I  CV�n��m�n (0 updateprojectonweb updateProjectOnWeb� ��� o  CF�l�l $0 projectnamevalue projectNameValue� ��� m  FG�k�k � ��� m  GJ��      � ��� o  JM�j�j 0 enddatetime endDateTime� ��i� o  MP�h�h 0 
errorcount 
errorCount�i  �m  �  f  BC� ��g� I Wr�f��
�f .sysodlogaskr        TEXT� m  WZ�� 9 3IRIS Work export to tab delimited file is complete!   � �e��
�e 
btns� J  ]b�� ��d� m  ]`��  OK   �d  � �c��
�c 
dflt� m  eh��  OK   � �b��a
�b 
givu� m  kl�`�`  �a  �g  	" m  �	  m  �_�_p��  	 ��^� l     �]�\�]  �\  �^       �[����������������[  � �Z�Y�X�W�V�U�T�S�R�Q�P�O�N�M�Z *0 getcreatorauthority getCreatorAuthority�Y *0 getcultureauthority getCultureAuthority�X &0 getdatetimestring getDateTimeString�W (0 getperiodauthority getPeriodAuthority�V "0 getsitelongname getSiteLongName�U *0 getsubjectauthority getSubjectAuthority�T *0 getsubtypeauthority getSubtypeAuthority�S ,0 getworktypeauthority getWorkTypeAuthority�R 
0 joinby  �Q 0 listtrim listTrim�P 0 	righttrim 	rightTrim�O (0 updateprojectonweb updateProjectOnWeb�N 0 write_to_file  
�M .aevtoappnull  �   � ****� �L�K�J���I�L *0 getcreatorauthority getCreatorAuthority�K �H��H �  �G�G 0 creatorlist creatorList�J  � �F�E�D�C�B�A�F 0 creatorlist creatorList�E 0 authoritylist authorityList�D 0 creatorcount creatorCount�C 0 i  �B 0 	authority  �A 0 	creatorid 	creatorID� ��@�?�>�=7�<�;L�:�9W�8�7�6h�5�4r�3�2z�1�0�/���.��-�,
�@ 
cDB �? 0 iriscreation irisCreation
�> 
list
�= .corecnte****       ****
�< 
ctxt
�; 
cobj
�: 
cRQT
�9 
ccel
�8 
cwin
�7 .FMPRFINDnull���    obj 
�6 
pCRW
�5 
vlue
�4 .coredoexbool        obj �3  �2  �1 0 
errorcount 
errorCount�0 "0 outputdirectory outputDirectory�/ 0 errorlog errorLog�. 0 
worknumber 
workNumber�- 0 newline newLine�, 0 write_to_file  �I �� �*��/ �jv�&E�O�j E�O �k�kh ��&E�O��/�&E�O I�� ?��&*�k/��/FO*�k/j O*�,��/a ,j  *�,�a /a ,�&E�Y hY hW ?X  a �&E�O_ kE` O)_ _ %a _ %a %_ %a %�%_ %em+ O��%�&E�[OY�\UUO�� �+��*�)���(�+ *0 getcultureauthority getCultureAuthority�* �'��' �  �&�& 0 culturelist cultureList�)  � �%�$�#�"�!�% 0 culturelist cultureList�$ 0 authoritylist authorityList�# 0 culturecount cultureCount�" 0 i  �! 0 	authority  � �� ��������������������<=�>��
�  
cDB � 0 irisculture irisCulture
� 
list
� .corecnte****       ****
� 
ctxt
� 
cobj
� 
cRQT
� 
ccel
� 
cwin
� .FMPRFINDnull���    obj 
� 
pCRW
� 
vlue
� .coredoexbool        obj �  �  � 0 
errorcount 
errorCount� "0 outputdirectory outputDirectory� 0 errorlog errorLog� 0 
worknumber 
workNumber� 0 newline newLine� 0 write_to_file  �( �� �*��/ �jv�&E�O�j E�O �k�kh ��&E�O O��/� B��/�&*�k/��/FO*�k/j O*�,��/a ,j  *�,�a /a ,�&E�Y hY hW BX  a �&E�O_ kE` O)_ _ %a _ %a %_ %a %��/%_ %em+ O��%�&E�[OY�\UUO�� �V�
�	 �� &0 getdatetimestring getDateTimeString�
 ��   �� 0 
dateobject 
dateObject�	    ������ ��������������� 0 
dateobject 
dateObject� 0 d  � 0 daystr dayStr� 0 m  � 0 monstr monStr�  0 y  �� 0 secs  �� 0 hrstr hrStr�� 0 min  �� 0 minstr minStr�� 0 secstr secStr��  0 datetimestring dateTimeString�� 0 h   +����{����������������������������������������������,3��V]l�����
�� 
day �� 

�� 
ctxt
�� 
mnth
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
year
�� 
time���� <����,E�O�� �%�&E�Y ��&E�O��,E�O��  �E�Y ���  �E�Y ���  �E�Y ���  �E�Y }��  �E�Y q��  
a E�Y c�a   
a E�Y S�a   
a E�Y C�a   
a E�Y 3�a   
a E�Y #�a   
a E�Y �a   
a E�Y hO�a ,E�O�a ,E�O�a  ,�a "E�O�a #E�O�� a  �%�&E�Y ��&E�Y a !E�O�a " ,�a ""E�O�a "#E�O�� a #�%�&E�Y ��&E�Y a $E�O�� a %�%�&E�Y ��&E�O�a &%�%a '%�%a (%�%a )%�%a *%�%�&E�� ����������� (0 getperiodauthority getPeriodAuthority�� ����   ���� 0 
periodlist 
periodList��   ������������ 0 
periodlist 
periodList�� 0 authoritylist authorityList�� 0 periodcount periodCount�� 0 i  �� 0 	authority   ������������������������������������������$%��&����
�� 
cDB �� 0 
irisperiod 
irisPeriod
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
errorCount�� "0 outputdirectory outputDirectory�� 0 errorlog errorLog�� 0 
worknumber 
workNumber�� 0 newline newLine�� 0 write_to_file  �� �� �*��/ �jv�&E�O�j E�O �k�kh ��&E�O O��/� B��/�&*�k/��/FO*�k/j O*�,��/a ,j  *�,�a /a ,�&E�Y hY hW BX  a �&E�O_ kE` O)_ _ %a _ %a %_ %a %��/%_ %em+ O��%�&E�[OY�\UUO�� ��>�������� "0 getsitelongname getSiteLongName�� ����   ����  0 concatsitename concatSiteName��   ��������  0 concatsitename concatSiteName�� 0 sitelongname siteLongName�� 0 
regionlist 
regionList *T��\���������n��������������������������$+9����������de��f����
�� 
ctxt
�� 
cDB �� 0 irissite irisSite
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
�� .coredoexbool        obj �� 0 	righttrim 	rightTrim
�� 
list
�� 
cobj��  ��  �� 0 
errorcount 
errorCount�� "0 outputdirectory outputDirectory�� 0 errorlog errorLog�� 0 
worknumber 
workNumber�� 0 newline newLine�� 0 write_to_file  �����&E�O��y�q*��/i1��&*�k/��/FO*�k/j 
O*�,��/�,j  �*�,��/�,%�&E�O)�k+ �&E�Y hO*�,�a /�,j  �*�,�a /�,a &E�O�a k/a  2�a  �a %�&E�Y hO��a k/%�&E�O)�k+ �&E�Y hO�a l/a  2�a  �a %�&E�Y hO��a l/%�&E�O)�k+ �&E�Y hY hO*�,�a /�,j  6�a  �a %�&E�Y hO�*�,�a /�,%�&E�O)�k+ �&E�Y hW 7X   _ !kE` !O)_ "_ #%a $_ !%a %%_ &%a '%�%_ (%em+ )UUY hO�� ��s����	
���� *0 getsubjectauthority getSubjectAuthority�� ����   ���� 0 subjectlist subjectList��  	 ������������ 0 subjectlist subjectList�� 0 authoritylist authorityList�� 0 subjectcount subjectCount�� 0 i  �� 0 	authority  
 ������������������������������������������� ������
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
errorCount�� "0 outputdirectory outputDirectory�� 0 errorlog errorLog�� 0 
worknumber 
workNumber�� 0 newline newLine�� 0 write_to_file  �� �� �*��/ �jv�&E�O�j E�O �k�kh ��&E�O O��/� B��/�&*�k/��/FO*�k/j O*�,��/a ,j  *�,�a /a ,�&E�Y hY hW BX  a �&E�O_ kE` O)_ _ %a _ %a %_ %a %��/%_ %em+ O��%�&E�[OY�\UUO�� ���������� *0 getsubtypeauthority getSubtypeAuthority�� ����   ���� 0 subtypelist subtypeList��   ����~�}�|�� 0 subtypelist subtypeList� 0 authoritylist authorityList�~ 0 subtypecount subtypeCount�} 0 i  �| 0 	authority   ��{�z�y�xI�w�vX�u�tf�s�r�qw�p�o��n�m��l�k�j���i��h�g
�{ 
cDB �z 0 irissubtype irisSubtype
�y 
list
�x .corecnte****       ****
�w 
ctxt
�v 
cobj
�u 
cRQT
�t 
ccel
�s 
cwin
�r .FMPRFINDnull���    obj 
�q 
pCRW
�p 
vlue
�o .coredoexbool        obj �n  �m  �l 0 
errorcount 
errorCount�k "0 outputdirectory outputDirectory�j 0 errorlog errorLog�i 0 
worknumber 
workNumber�h 0 newline newLine�g 0 write_to_file  �� �� �*��/ �jv�&E�O�j E�O �k�kh ��&E�O O��/� B��/�&*�k/��/FO*�k/j O*�,��/a ,j  *�,�a /a ,�&E�Y hY hW BX  a �&E�O_ kE` O)_ _ %a _ %a %_ %a %��/%_ %em+ O��%�&E�[OY�\UUO�� �f��e�d�c�f ,0 getworktypeauthority getWorkTypeAuthority�e �b�b   �a�a 0 worktypelist workTypeList�d   �`�_�^�]�\�` 0 worktypelist workTypeList�_ 0 authoritylist authorityList�^ 0 worktypecount workTypeCount�] 0 i  �\ 0 	authority   ��[�Z�Y�X��W�V��U�T�S�R�Q�P�O(�N�M0�L�K�JNO�IP�H�G
�[ 
cDB �Z 0 irisworktype irisWorkType
�Y 
list
�X .corecnte****       ****
�W 
ctxt
�V 
cobj
�U 
cRQT
�T 
ccel
�S 
cwin
�R .FMPRFINDnull���    obj 
�Q 
pCRW
�P 
vlue
�O .coredoexbool        obj �N  �M  �L 0 
errorcount 
errorCount�K "0 outputdirectory outputDirectory�J 0 errorlog errorLog�I 0 
worknumber 
workNumber�H 0 newline newLine�G 0 write_to_file  �c �� �*��/ �jv�&E�O�j E�O �k�kh ��&E�O O��/� B��/�&*�k/��/FO*�k/j O*�,��/a ,j  *�,�a /a ,�&E�Y hY hW BX  a �&E�O_ kE` O)_ _ %a _ %a %_ %a %��/%_ %em+ O��%�&E�[OY�\UUO�� �Fh�E�D�C�F 
0 joinby  �E �B�B   �A�@�A 0 somestrings  �@ 	0 delim  �D   �?�>�=�<�? 0 somestrings  �> 	0 delim  �= 0 olddelim oldDelim�< 
0 retval   �;�:�9�8�7
�; 
ascr
�: 
txdl
�9 
TEXT�8  �7  �C + ��,E�O���,FO��&E�O���,FW X  ���,FO�� �6��5�4�3�6 0 listtrim listTrim�5 �2�2   �1�1 0 lstvalue lstValue�4   �0�/�.�-�,�0 0 lstvalue lstValue�/ 0 newlist newList�. 0 numitems numItems�- 0 i  �, 0 tempitem tempItem �+�*�)�(�'
�+ 
list
�* .corecnte****       ****
�) 
cobj
�( 
ctxt�' 0 	righttrim 	rightTrim�3 7jv�&E�O�j E�O #k�kh ��/�&E�O�)�k+ %�&E�[OY��O�� �&��%�$�#�& 0 	righttrim 	rightTrim�% �"�"   �!�! 0 strvalue strValue�$   � �����  0 strvalue strValue� 0 strindex strIndex� 0 lastchar lastChar�  0 carriagereturn carriageReturn� 0 	spacechar 	spaceChar ��������"7>� 
� .sysontocTEXT       shor
� 
ctxt�  
� 
leng
� 
cha � 0 newline newLine
� 
bool�# ��j �&E�O�j �&E�O��,E�O�j  �Y a��/E�O >h�� 
 �� �&
 �� �&�j 
�kE�Y hO�j ��/E�Y �E�[OY��O�� �[�\[Zk\Z�2EY �� �G���� (0 updateprojectonweb updateProjectOnWeb� ��   �����
� 0 projname projName� 0 stepnum stepNum� 0 	starttime 	startTime� 0 
finishtime 
finishTime�
 0 
errorcount 
errorCount�   �	�������	 0 projname projName� 0 stepnum stepNum� 0 	starttime 	startTime� 0 
finishtime 
finishTime� 0 
errorcount 
errorCount� 0 urltext urlText� 0 i   �d�� y������������� .0 imageprojectstatusurl imageProjectStatusURL
� 
ctxt
�  
bool
�� .GURLGURLnull��� ��� TEXT�� 

�� .aevtquitnull���    obj � x��%�%�&E�O�k 
 �l �& ��%�%�&E�Y hO�� ��%�%�&E�Y hO�� ��%�%�&E�Y hO��%�%�&E�O� �j O k�kh hY��O*j U� ����������� 0 write_to_file  �� �� ��    �������� 0 the_file  �� 0 
the_string  �� 0 	appending  ��   ���������� 0 the_file  �� 0 
the_string  �� 0 	appending  �� 0 
write_file   ��������������������������������
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
�� .rdwrclosnull���     ****��  ��  �� S��&E�O 5*�/�el E�O�f  ��jl Y hO������� O�j W X   
�j W X  h� ��!����"#��
�� .aevtoappnull  �   � ****! k    t$$  ^%%  d&&  r''  {((  �))  �**  �++  �,,  �--  �..  �//  �00  �11  �22  �33  �44  �55  �66  �77  �88  �99  �::  �;; �<< �== �>> 	?? 	����  ��  ��  " ������ 0 i  �� 0 	workindex 	workIndex#- c�� m n�� w�� ����� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� �������������������������������		�����	+��	-����������������	P����	Z��	n��	�	�
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
K
L
M
N
O
P
Q
R
S
T
U
V
W
X
Y
Z
[
\
]
^
_
`
a
b
c
d
e
f
g
h
i��
�
�
�
���������
�
���
�
���	
��+,��MN��op������������������,����@��<������LM��������y����������������������B�V�n�~�����~��}��|�{�z���y�x�w�v*:�uJ�tV�s�r�q|�p�o�n��m����l����k�j*8�i=EK[�hk�g{�f��e��d��c��b��a��`�_�^��]�\�[�Z�YWcuv����X��W���V��U��T�S�� 0 irispassword irisPassword�� (0 irisremotelocation irisRemoteLocation�� "0 outputdirectory outputDirectory
�� 
ctxt�� .0 imageprojectstatusurl imageProjectStatusURL�� 0 	irisworks 	irisWorks�� 0 iriswcreator irisWCreator�� 0 irisworktype irisWorkType�� 0 
iristitles 
irisTitles�� 0 irisculture irisCulture�� 0 
irisperiod 
irisPeriod�� 0 irissubject irisSubject�� 0 irissubtype irisSubtype�� 0 iriscreation irisCreation��  0 irisrepository irisRepository�� 0 irissite irisSite�� 40 outputstatisticsfilename outputStatisticsFilename�� $0 outputworknofile outputWorkNoFile�� 0 errorlog errorLog�� 	
�� .sysontocTEXT       shor��  0 fieldseparator fieldSeparator�� ��  0 valueseparator valueSeparator�� 
�� 0 newline newLine�� 0 
errorcount 
errorCount�� $0 projectworkcount projectWorkCount
�� .earslvolutxt  P ��� null�� 0 
volumelist 
volumeList�� ,0 dropboxvolumemounted dropboxVolumeMounted
�� .corecnte****       ****
�� 
cobj
�� .aevtmvolnull���     TEXT��p
�� 
dtxt
�� .sysodlogaskr        TEXT
�� 
rslt
�� 
ttxt�� $0 projectnamevalue projectNameValue
�� .misccurdldt    ��� null�� 0 	starttime 	startTime�� &0 getdatetimestring getDateTimeString�� 0 startdatetime startDateTime�� �� (0 updateprojectonweb updateProjectOnWeb��  0 outputfilename outputFilename�� 0 write_to_file  �� 0 
headerline 
headerLine
�� .GURLGURLnull��� ��� TEXT
�� 
cDB ��  0 iriscreationdb irisCreationDB
�� .coredoexbool        obj �� 0 irisculturedb irisCultureDB�� 0 irisperioddb irisPeriodDB��  0 irisworktypedb irisWorkTypeDB�� 0 
irissitedb 
irisSiteDB�� $0 irisrepositorydb irisRepositoryDB�� 0 iristitlesdb irisTitlesDB��  0 iriswcreatordb irisWCreatorDB�� 0 irissubjectdb irisSubjectDB�� 0 irissubtypedb irisSubtypeDB�� 0 irisworksdb irisWorksDB
�� 
crow
�� 
ID  @  
�� 
ccel
�� 
vlue
�� 
list�� 0 worklist workList�� 0 	workcount 	workCount
�� 
long
�� kfrmID  �� 0 
workrecord 
workRecord�� 0 
worknumber 
workNumber� 0 	righttrim 	rightTrim� "0 workprojectname workProjectName� 0 	worktitle 	workTitle� 0 listtrim listTrim� (0 worktitlequalifier workTitleQualifier�  0 workcategories workCategories� 0 worksubjects workSubjects� *0 getsubjectauthority getSubjectAuthority� ,0 worksubjectauthority workSubjectAuthority� *0 worksubjectsubtypes workSubjectSubtypes� *0 getsubtypeauthority getSubtypeAuthority� :0 worksubjectsubtypeauthority workSubjectSubtypeAuthority� 0 workmaterials workMaterials� 0 workcentury workCentury� 0 workstartyear workStartYear� 0 workendyear workEndYear� 0 	workdates 	workDates�~ 0 workera workEra�} 0 workcountry workCountry�| 0 worktype workType�{ ,0 getworktypeauthority getWorkTypeAuthority�z &0 worktypeauthority workTypeAuthority�y  0 workconcatsite workConcatSite�x "0 getsitelongname getSiteLongName�w "0 workcurrentsite workCurrentSite�v  0 workformersite workFormerSite�u 0 worklocality workLocality�t  0 workdimensions workDimensions�s 0 workculture workCulture�r *0 getcultureauthority getCultureAuthority�q ,0 workcultureauthority workCultureAuthority�p 0 
workperiod 
workPeriod�o (0 getperiodauthority getPeriodAuthority�n *0 workperiodauthority workPeriodAuthority�m  0 worktechniques workTechniques�l .0 workrepositorydisplay workRepositoryDisplay�k 40 workrepositoryconcatsite workRepositoryConcatSite�j *0 workrepositoryplace workRepositoryPlace�i 20 workrepositoryauthority workRepositoryAuthority�h ,0 workrepositorynumber workRepositoryNumber�g 0 workcollector workCollector�f *0 workcatalogersnotes workCatalogersNotes�e 0 workpid workPID�d 0 creatoridlist creatorIdList�c "0 workcreatorname workCreatorName�b ,0 workcreatorqualifier workCreatorQualifier�a "0 workcreatorrole workCreatorRole�` $0 workcreatordates workCreatorDates�_ *0 getcreatorauthority getCreatorAuthority�^ ,0 workcreatorauthority workCreatorAuthority�]  0 workexportdate workExportDate�\  0 worktitlecount workTitleCount�[ $0 workcreatorcount workCreatorCount�Z 
0 joinby  �Y (0 workmetadatastring workMetadataString�X 0 endtime endTime�W 0 enddatetime endDateTime
�V 
btns
�U 
dflt
�T 
givu�S ��u�E�O��%�%E�O�E�O��&E�O�E�O�E�O�E�Oa E` Oa E` Oa E` Oa E` Oa E` Oa E` Oa E` Oa E` Oa  E` !Oa "E` #Oa $E` %Oa &j '�&E` (Oa )j '�&E` *Oa +j '�&E` ,OjE` -OjE` .O*j /E` 0OfE` 1O ,k_ 0j 2kh  _ 0a 3�/a 4  
eE` 1Y h[OY��O_ 1 a 5j 6Y hOa 7na 8ia 9a :a ;l <O_ =a >,E` ?O*j @E` AO)_ Ak+ B�&E` CO)_ ?k_ Ca Dja E+ FO_ ?a G%�&E` HO)�_ !%a I_ ,%fm+ JO)�_ !%a K_ A%_ ,%em+ JO)�_ !%a L_ ?%_ ,%em+ JOa M_ (%a N%_ (%a O%_ (%a P%_ (%a Q%_ (%a R%_ (%a S%_ (%a T%_ (%a U%_ (%a V%_ (%a W%_ (%a X%_ (%a Y%_ (%a Z%_ (%a [%_ (%a \%_ (%a ]%_ (%a ^%_ (%a _%_ (%a `%_ (%a a%_ (%a b%_ (%a c%_ (%a d%_ (%a e%_ (%a f%_ (%a g%_ (%a h%_ (%a i%_ (%a j%_ (%a k%_ (%a l%_ (%a m%_ (%a n%_ (%a o%_ (%a p%_ (%a q%_ (%a r%_ (%a s%_ (%a t%_ (%a u%_ ,%�&E` vO)�_ H%_ vfm+ JO)�_ %%a wfm+ JO)�_ #%a x_ (%a y%_ (%a z%_ ,%fm+ JO�_ %j {O*a |_ /E` }O_ }j ~f  a _ %a �%j <OhY hO�_ %j {O*a |_ /E` �O_ �j ~f  a �_ %a �%j <OhY hO�_ %j {O*a |_ /E` �O_ �j ~f  a �_ %a �%j <OhY hO��%j {O*a |�/E` �O_ �j ~f  a ��%a �%j <OhY hO�_ %j {O*a |_ /E` �O_ �j ~f  a �_ %a �%j <OhY hO�_ %j {O*a |_ /E` �O_ �j ~f  a �_ %a �%j <OhY hO�_ %j {O*a |_ /E` �O_ �j ~f  a �_ %a �%j <OhY hO��%j {O*a |�/E` �O_ �j ~f  a ��%a �%j <OhY hO�_ %j {O*a |_ /E` �O_ �j ~f  a �_ %a �%j <OhY hO�_ %j {O*a |_ /E` �O_ �j ~f  a �_ %a �%j <OhY hO��%j {O*a |�/E` �O_ �j ~f  a ��%a �%j <OhY hO*a |�/	c_ ?a � ,*a �-a �,a �[a �a �/a �,\Z_ ?81a �&E` �Y )*a �-a �,a �[a �a �/a �,\Za �91a �&E` �O_ �j 2E` �O�k_ �kh *a �_ �a 3�/a �&a �0E` �O_ �a �a �/a �,E` �O_ �a �a �/a �,a �6_ .kE` .O_ �a �a �/a �,E` �O)_ �a �a �/a �,k+ ��&E` �O_ �a �a �/a �,a �&E` �O)_ �k+ �E` �O_ �a �a �/a �,a �&E` �O)_ �k+ �E` �O_ �a �a �/a �,a �&E` �O)_ �k+ �E` �O_ �a �a �/a �,a �&E` �O)_ �k+ �E` �O)_ �k+ �a �&E` �O)_ �k+ �E` �O_ �a �a �/a �,a �&E` �O)_ �k+ �E` �O)_ �k+ �a �&E` �O)_ �k+ �E` �O_ �a �a �/a �,a �&E` �O)_ �k+ �E` �O_ �a �a �/a �,a �&E` �O)_ �k+ �E` �O)_ �a �a �/a �,k+ ��&E` �O)_ �a �a �/a �,k+ ��&E` �O)_ �a �a �/a �,k+ ��&E` �O)_ �a �a �/a �,k+ ��&E` �O_ �a �a �/a �,a �&E` �O)_ �k+ �E` �O_ �a �a �/a �,a �&E` �O)_ �k+ �E` �O)_ �k+ �a �&E` �O)_ �k+ �E` �O_ �a �a �/a �,j ~ (_ �a �a �/a �,�&E` �O)_ �k+ ��&E` �Y a ��&E` �O_ �a �a �/a �,j ~ (_ �a �a �/a �,�&E` �O)_ �k+ ��&E` �Y a ��&E` �O)_ �a �a �/a �,k+ ��&E` �O)_ �a �a �/a �,k+ ��&E` �O_ �a �a �/a �,a �&E` �O)_ �k+ �E` �O)_ �k+ �a �&E` �O)_ �k+ �E` �O_ �a �a �/a �,a �&E` �O)_ �k+ �E` �O)_ �k+ �a �&E` �O)_ �k+ �E` �O_ �a �a �/a �,a �&E` �O)_ �k+ �E` �O_ �a �a �/a �,j ~ �_ �a �a �/a �,j ~ )_ �a �a �/a �,k+ ��&E` �Y a ��&E` �O_ �a �a �/a �,j ~ (_ �a �a �/a �,�&E` �O)_ �k+ ��&E` �Y a ��&E` �O_ �a � _ �a �%�&E` �Y hO_ �_ �%�&E` �O_ �a �a �/a �,j ~ )_ �a �a �/a �,k+ ��&E` �Y a ��&E` �Y a ��&E` �Oa �&E` �O)_ �a �a/a �,k+ ��&E`O)_ �a �a/a �,k+ ��&E`O)_ �a �a/a �,k+ ��&E`O_ �a �a/a �,�&E`O_ �a �a	/a �,a �&E`
O_ �a �a/a �,a �&E`O)_k+ �E`O_ �a �a/a �,a �&E`O)_k+ �E`O_ �a �a/a �,a �&E`O)_k+ �E`O_ �a �a/a �,a �&E`O)_k+ �E`O)_
k+a �&E`O)_k+ �E`O_ �a �a/a �,E`O_ �j 2E`O_
j 2E`O_ �_ (%_%_ (%_ �%_ (%)_ �_ *l+%_ (%)_ �_ *l+%_ (%)_ �_ *l+%_ (%)_ �_ *l+%_ (%)_ �_ *l+%_ (%)_ �_ *l+%_ (%)_ �_ *l+%_ (%_ �%_ (%_ �%_ (%_ �%_ (%_ �%_ (%_ �%_ (%)_ �_ *l+%_ (%)_ �_ *l+%_ (%_ �%_ (%)_ �_ *l+%_ (%)_ �_ *l+%_ (%)_ �_ *l+%_ (%)_ �_ *l+%_ (%)_ �_ *l+%_ (%_ �%_ (%_ �%_ (%_%_ (%)_ �_ *l+%_ (%)_ �_ *l+%_ (%_%_ (%)__ *l+%_ (%)__ *l+%_ (%)__ *l+%_ (%)__ *l+%_ (%)__ *l+%_ (%_ �%_ (%_ �%_ (%_ �%_ (%_%_ (%_%_ (%_%_ (%_%�&E`O)�_ H%__ ,%em+ JO)�_ #%a_ �%_ (%_ �%_ (%_%_ ,%em+ JY /_ �a �a/a �,E` �O)�_ !%a_ �%a%_ ,%em+ J[OY�WO)�_ !%a_ �%_ ,%em+ JO)�_ !%a _ .%_ ,%em+ JO)�_ !%a!_ -%_ ,%em+ JUO*j @E`"O)�_ !%a#_"%_ ,%em+ JO)_"k+ B�&E`$O)_ ?ka%_$_ -a E+ FOa&a'a(kva)a*a+ja, <Uoascr  ��ޭ