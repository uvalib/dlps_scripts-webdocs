FasdUAS 1.101.10   ��   ��    k             l     �� ��    y s This script is to be used as a folder action script for drop cropping each scanned image and copying them to Pogo.       	  l     �� 
��   
   Creator: Jack Kelly    	     l     �� ��    M G Copyright (C) 2005 by UVA Library, Digital Library Production Services         l     ������  ��        l     �� ��    G Aon adding folder items to this_folder after receiving these_items      ��  i         I     ��  
�� .facofgetnull���     alis  o      ���� 0 projectfolder projectFolder  �� ��
�� 
flst  o      ���� &0 scannedimagefiles scannedImageFiles��    k           l     �� ��      Initialize variables         r          I    �� !��
�� .corecnte****       **** ! o     ���� &0 scannedimagefiles scannedImageFiles��     o      ���� .0 scannedimagefilecount scannedImageFileCount   " # " r     $ % $ m    	����   % o      ���� 0 	copycount 	copyCount #  & ' & r     ( ) ( m    ����   ) o      ���� 0 
errorcount 
errorCount '  * + * r     , - , m     . .       - o      ���� 0 errormessage errorMessage +  / 0 / l   ������  ��   0  1 2 1 O    u 3 4 3 k    t 5 5  6 7 6 r     8 9 8 n     : ; : 1    ��
�� 
pnam ; o    ���� 0 projectfolder projectFolder 9 o      ���� 0 projectname projectName 7  < = < l   ������  ��   =  > ? > l   �� @��   @ A ; Check to see if an output directory was already specified.    ?  A�� A Z    t B C�� D B l   # E�� E =    # F G F l   ! H�� H n    ! I J I 1    !��
�� 
comt J o    ���� 0 projectfolder projectFolder��   G m   ! " K K      ��   C k   & E L L  M N M l  & &�� O��   O ; 5 Choose the destination folder for the project files.    N  P Q P r   & 3 R S R I  & 1���� T
�� .sysostflalis    ��� null��   T �� U��
�� 
prmp U b   ( - V W V b   ( + X Y X m   ( ) Z Z 2 ,Choose the project folder on Pogo where the     Y o   ) *���� 0 projectname projectName W m   + , [ [    scanned images should go:   ��   S o      ���� &0 destinationfolder destinationFolder Q  \ ] \ r   4 9 ^ _ ^ n   4 7 ` a ` 1   5 7��
�� 
psxp a o   4 5���� &0 destinationfolder destinationFolder _ o      ���� "0 outputdirectory outputDirectory ]  b c b r   : ? d e d c   : = f g f o   : ;���� "0 outputdirectory outputDirectory g m   ; <��
�� 
TEXT e o      ���� 0 
outputtext 
outputText c  h�� h r   @ E i j i o   @ A���� 0 
outputtext 
outputText j l      k�� k n       l m l 1   B D��
�� 
comt m o   A B���� 0 projectfolder projectFolder��  ��  ��   D Q   H t n o p n k   K [ q q  r s r r   K R t u t c   K P v w v l  K N x�� x n   K N y z y 1   L N��
�� 
comt z o   K L���� 0 projectfolder projectFolder��   w m   N O��
�� 
TEXT u o      ����  0 destinationdir destinationDir s  {�� { r   S [ | } | c   S Y ~  ~ l  S W ��� � 4   S W�� �
�� 
psxf � o   U V����  0 destinationdir destinationDir��    m   W X��
�� 
alis } o      ���� &0 destinationfolder destinationFolder��   o R      ������
�� .ascrerr ****      � ****��  ��   p k   c t � �  � � � r   c n � � � b   c l � � � b   c h � � � o   c d���� 0 errormessage errorMessage � m   d g � � 4 .ERROR: Unable to read directory comment field.    � o   h k��
�� 
ret  � o      ���� 0 errormessage errorMessage �  ��� � r   o t � � � [   o r � � � o   o p���� 0 
errorcount 
errorCount � m   p q����  � o      ���� 0 
errorcount 
errorCount��  ��   4 m     � ��null     ߀��  b
Finder.app���K���L��P�����    |0(   )       �(�KK���@ }MACS   alis    r  Macintosh HD               ����H+    b
Finder.app                                                       C���y        ����  	                CoreServices    ����      ���W      b  Z  Y  3Macintosh HD:System:Library:CoreServices:Finder.app    
 F i n d e r . a p p    M a c i n t o s h   H D  &System/Library/CoreServices/Finder.app  / ��   2  � � � l  v v������  ��   �  � � � l  v v�� ���   � @ : For each file in this project folder do the following...	    �  � � � X   v � ��� � � k   � � � �  � � � O   � � � � � r   � � � � � n   � � � � � 1   � ���
�� 
pnam � o   � ����� 0 	imagefile 	imageFile � o      ���� 0 	imagename 	imageName � m   � � � �  � � � l  � ��� ���   � , & Copy the file to the server location.    �  ��� � O   � � � � � Q   � � � � � � k   � � � �  � � � I  � ��� � �
�� .coreclon****      � **** � o   � ����� 0 	imagefile 	imageFile � �� � �
�� 
insh � o   � ����� &0 destinationfolder destinationFolder � �� ���
�� 
alrp � m   � ���
�� savoyes ��   �  ��� � r   � � � � � [   � � � � � o   � ����� 0 	copycount 	copyCount � m   � �����  � o      ���� 0 	copycount 	copyCount��   � R      ������
�� .ascrerr ****      � ****��  ��   � k   � � � �  � � � r   � � � � � b   � � � � � b   � � � � � b   � � � � � b   � � � � � b   � � � � � o   � ����� 0 errormessage errorMessage � m   � � � �  ERROR: Unable to copy     � o   � ����� 0 	imagename 	imageName � m   � � � � 
  to     � o   � ����� "0 outputdirectory outputDirectory � o   � ���
�� 
ret  � o      ���� 0 errormessage errorMessage �  ��� � r   � � � � � [   � � � � � o   � ����� 0 
errorcount 
errorCount � m   � �����  � o      ���� 0 
errorcount 
errorCount��   � m   � � ���  �� 0 	imagefile 	imageFile � o   y z���� &0 scannedimagefiles scannedImageFiles �  � � � l  � �������  ��   �  � � � l  � ��� ���   � 0 * Display the results of the folder action.    �  � � � l  � ��� ���   � s mset resultsMessage to "" & scannedImageFileCount & " items found in the " & projectName & " folder." & return    �  � � � l  � ��� ���   � � {set resultsMessage to resultsMessage & copyCount & " files successfully copied to " & outputDirectory & " folder." & return    �  ��� � Z   � � ����� � l  � � ��� � >   � � � � � o   � ����� 0 
errorcount 
errorCount � m   � �����  ��   � k   � � �  � � � r   � � � � � b   � � � � � b   � � � � � b   � � � � � b   � � � � � o   � �����  0 resultsmessage resultsMessage � m   � � � �  There were     � o   � ����� 0 
errorcount 
errorCount � m   � � � �   errors:    � o   � ���
�� 
ret  � o      ����  0 resultsmessage resultsMessage �  � � � r   � � � � � b   � � � � � o   � �����  0 resultsmessage resultsMessage � o   � ����� 0 errormessage errorMessage � o      ����  0 resultsmessage resultsMessage �  ��� � I  �� � �
� .sysodlogaskr        TEXT � o   � ��~�~  0 resultsmessage resultsMessage � �} � �
�} 
btns � J   � � �  ��| � m   �  � �  OK   �|   � �{ ��z
�{ 
dflt � m  �y�y �z  ��  ��  ��  ��  ��       �x � �x   � �w
�w .facofgetnull���     alis  �v �u�t�s
�v .facofgetnull���     alis�u 0 projectfolder projectFolder�t �r�q�p
�r 
flst�q &0 scannedimagefiles scannedImageFiles�p   �o�n�m�l�k�j�i�h�g�f�e�d�c�b�o 0 projectfolder projectFolder�n &0 scannedimagefiles scannedImageFiles�m .0 scannedimagefilecount scannedImageFileCount�l 0 	copycount 	copyCount�k 0 
errorcount 
errorCount�j 0 errormessage errorMessage�i 0 projectname projectName�h &0 destinationfolder destinationFolder�g "0 outputdirectory outputDirectory�f 0 
outputtext 
outputText�e  0 destinationdir destinationDir�d 0 	imagefile 	imageFile�c 0 	imagename 	imageName�b  0 resultsmessage resultsMessage !�a . ��`�_ K�^ Z [�]�\�[�Z�Y�X�W ��V�U�T�S�R�Q�P�O � � � ��N ��M�L
�a .corecnte****       ****
�` 
pnam
�_ 
comt
�^ 
prmp
�] .sysostflalis    ��� null
�\ 
psxp
�[ 
TEXT
�Z 
psxf
�Y 
alis�X  �W  
�V 
ret 
�U 
kocl
�T 
cobj
�S 
insh
�R 
alrp
�Q savoyes �P 
�O .coreclon****      � ****
�N 
btns
�M 
dflt
�L .sysodlogaskr        TEXT�s�j  E�OjE�OjE�O�E�O� ^��,E�O��,�  $*��%�%l 	E�O��,E�O��&E�O���,FY . ��,�&E�O*�/�&E�W X  �a %_ %E�O�kE�UO c�[a a l  kh � ��,E�UO� = �a �a a a  O�kE�W  X  �a %�%a %�%_ %E�O�kE�U[OY��O�j 0�a %�%a %_ %E�O��%E�O�a a kva ka   Y hascr  ��ޭ