FasdUAS 1.101.10   ��   ��    k             l     �� ��    y s This script is to be used as a folder action script for drop cropping each scanned image and copying them to Pogo.       	  l     �� 
��   
   Creator: Jack Kelly    	     l     �� ��    M G Copyright (C) 2005 by UVA Library, Digital Library Production Services         l     ������  ��        l     �� ��    G Aon adding folder items to this_folder after receiving these_items      ��  i         I     ��  
�� .facofgetnull���     alis  o      ���� 0 projectfolder projectFolder  �� ��
�� 
flst  o      ���� &0 scannedimagefiles scannedImageFiles��    k     �       l     �� ��      Initialize variables         r          I    �� !��
�� .corecnte****       **** ! o     ���� &0 scannedimagefiles scannedImageFiles��     o      ���� .0 scannedimagefilecount scannedImageFileCount   " # " r     $ % $ m    	����   % o      ���� 0 	copycount 	copyCount #  & ' & r     ( ) ( m    ����   ) o      ���� 0 
errorcount 
errorCount '  * + * r     , - , m     . .       - o      ���� 0 errormessage errorMessage +  / 0 / l   ������  ��   0  1 2 1 O    2 3 4 3 k    1 5 5  6 7 6 r     8 9 8 n     : ; : 1    ��
�� 
pnam ; o    ���� 0 projectfolder projectFolder 9 o      ���� 0 projectname projectName 7  < = < l   ������  ��   =  > ? > l   �� @��   @ ; 5 Choose the destination folder for the project files.    ?  A B A r    + C D C I   )���� E
�� .sysostflalis    ��� null��   E �� F��
�� 
prmp F b     % G H G b     # I J I m     ! K K 2 ,Choose the project folder on Pogo where the     J o   ! "���� 0 projectname projectName H m   # $ L L    scanned images should go:   ��   D o      ���� &0 destinationfolder destinationFolder B  M�� M r   , 1 N O N n   , / P Q P 1   - /��
�� 
psxp Q o   , -���� &0 destinationfolder destinationFolder O o      ���� "0 outputdirectory outputDirectory��   4 m     R R�null     ߀��  	�
Finder.app��0� ����� 2����` � ��(   )        (�� ��߀ �MACS   alis    Z  Main                       ��&NH+    	�
Finder.app                                                       2T���K        ����  	                CoreServices    ��^�      ���      	�  	�  	�  +Main:System:Library:CoreServices:Finder.app    
 F i n d e r . a p p  
  M a i n  &System/Library/CoreServices/Finder.app  / ��   2  S T S l  3 3������  ��   T  U V U l  3 3�� W��   W @ : For each file in this project folder do the following...	    V  X Y X X   3 � Z�� [ Z k   C � \ \  ] ^ ] O   C M _ ` _ r   G L a b a n   G J c d c 1   H J��
�� 
pnam d o   G H���� 0 	imagefile 	imageFile b o      ���� 0 	imagename 	imageName ` m   C D R ^  e f e l  N N������  ��   f  g h g l  N N�� i��   i 6 0 Copy the file to the destination folder on Pogo    h  j�� j O   N � k l k Q   R � m n o m k   U d p p  q r q I  U ^�� s t
�� .coreclon****      � **** s o   U V���� 0 	imagefile 	imageFile t �� u v
�� 
insh u o   W X���� &0 destinationfolder destinationFolder v �� w��
�� 
alrp w m   Y Z��
�� savoyes ��   r  x�� x r   _ d y z y [   _ b { | { o   _ `���� 0 	copycount 	copyCount | m   ` a����  z o      ���� 0 	copycount 	copyCount��   n R      ������
�� .ascrerr ****      � ****��  ��   o k   l � } }  ~  ~ r   l  � � � b   l } � � � b   l y � � � b   l w � � � b   l s � � � b   l q � � � o   l m���� 0 errormessage errorMessage � m   m p � �  ERROR: Unable to copy     � o   q r���� 0 	imagename 	imageName � m   s v � � 
  to     � o   w x���� "0 outputdirectory outputDirectory � o   y |��
�� 
ret  � o      ���� 0 errormessage errorMessage   ��� � r   � � � � � [   � � � � � o   � ����� 0 
errorcount 
errorCount � m   � �����  � o      ���� 0 
errorcount 
errorCount��   l m   N O R��  �� 0 	imagefile 	imageFile [ o   6 7���� &0 scannedimagefiles scannedImageFiles Y  � � � l  � �������  ��   �  � � � l  � ��� ���   � 0 * Display the results of the folder action.    �  � � � r   � � � � � b   � � � � � b   � � � � � b   � � � � � b   � � � � � b   � � � � � m   � � � �       � o   � ����� .0 scannedimagefilecount scannedImageFileCount � m   � � � �   items found in the     � o   � ����� 0 projectname projectName � m   � � � �   folder.    � o   � ���
�� 
ret  � o      ����  0 resultsmessage resultsMessage �  � � � r   � � � � � b   � � � � � b   � � � � � b   � � � � � b   � � � � � b   � � � � � o   � �����  0 resultsmessage resultsMessage � o   � ����� 0 	copycount 	copyCount � m   � � � � $  files successfully copied to     � o   � ����� "0 outputdirectory outputDirectory � m   � � � �   folder.    � o   � ���
�� 
ret  � o      ����  0 resultsmessage resultsMessage �  � � � Z   � � � ����� � l  � � ��� � >   � � � � � o   � ����� 0 
errorcount 
errorCount � m   � �����  ��   � k   � � � �  � � � r   � � � � � b   � � � � � b   � � � � � b   � � � � � b   � � � � � o   � �����  0 resultsmessage resultsMessage � m   � � � �  There were     � o   � ����� 0 
errorcount 
errorCount � m   � � � �   errors:    � o   � ���
�� 
ret  � o      ����  0 resultsmessage resultsMessage �  ��� � r   � � � � � b   � � � � � o   � �����  0 resultsmessage resultsMessage � o   � ����� 0 errormessage errorMessage � o      ����  0 resultsmessage resultsMessage��  ��  ��   �  ��� � I  � ��� � �
�� .sysodlogaskr        TEXT � o   � �����  0 resultsmessage resultsMessage � �� � �
�� 
btns � J   � � � �  ��� � m   � � � �  OK   ��   � �� ���
�� 
dflt � m   � ����� ��  ��  ��       �� � ���   � ��
�� .facofgetnull���     alis � �� ���� � ���
�� .facofgetnull���     alis�� 0 projectfolder projectFolder�� ������
�� 
flst�� &0 scannedimagefiles scannedImageFiles��   � ����������������������~�� 0 projectfolder projectFolder�� &0 scannedimagefiles scannedImageFiles�� .0 scannedimagefilecount scannedImageFileCount�� 0 	copycount 	copyCount�� 0 
errorcount 
errorCount�� 0 errormessage errorMessage�� 0 projectname projectName�� &0 destinationfolder destinationFolder�� "0 outputdirectory outputDirectory�� 0 	imagefile 	imageFile� 0 	imagename 	imageName�~  0 resultsmessage resultsMessage �  �} . R�|�{ K L�z�y�x�w�v�u�t�s�r�q�p � ��o � � � � � � ��n ��m�l
�} .corecnte****       ****
�| 
pnam
�{ 
prmp
�z .sysostflalis    ��� null
�y 
psxp
�x 
kocl
�w 
cobj
�v 
insh
�u 
alrp
�t savoyes �s 
�r .coreclon****      � ****�q  �p  
�o 
ret 
�n 
btns
�m 
dflt
�l .sysodlogaskr        TEXT�� �j  E�OjE�OjE�O�E�O� ��,E�O*��%�%l E�O��,E�UO W�[��l  kh 	� ��,E�UO� 5 ����� O�kE�W  X  �a %�%a %�%_ %E�O�kE�U[OY��Oa �%a %�%a %_ %E�O��%a %�%a %_ %E�O�j �a %�%a %_ %E�O��%E�Y hO�a a kva k� ascr  ��ޭ