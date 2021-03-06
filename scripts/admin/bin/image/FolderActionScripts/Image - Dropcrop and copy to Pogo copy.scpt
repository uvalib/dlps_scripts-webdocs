FasdUAS 1.101.10   ��   ��    k             l     �� ��    y s This script is to be used as a folder action script for drop cropping each scanned image and copying them to Pogo.       	  l     �� 
��   
   Creator: Jack Kelly    	     l     �� ��    M G Copyright (C) 2005 by UVA Library, Digital Library Production Services         l     ������  ��        l     ��  r         c         m               m    ��
�� 
ctxt  o      ���� "0 outputdirectory outputDirectory��        l     ������  ��        l     �� ��    G Aon adding folder items to this_folder after receiving these_items      ��  i         I     ��   !
�� .facofgetnull���     alis   o      ���� 0 projectfolder projectFolder ! �� "��
�� 
flst " o      ���� &0 scannedimagefiles scannedImageFiles��    k     � # #  $ % $ l     �� &��   &   Initialize variables    %  ' ( ' r      ) * ) I    �� +��
�� .corecnte****       **** + o     ���� &0 scannedimagefiles scannedImageFiles��   * o      ���� .0 scannedimagefilecount scannedImageFileCount (  , - , r     . / . m    	����   / o      ���� 0 	copycount 	copyCount -  0 1 0 r     2 3 2 m    ����   3 o      ���� 0 
errorcount 
errorCount 1  4 5 4 r     6 7 6 m     8 8       7 o      ���� 0 errormessage errorMessage 5  9 : 9 l   ������  ��   :  ; < ; O     = > = r     ? @ ? n     A B A 1    ��
�� 
pnam B o    ���� 0 projectfolder projectFolder @ o      ���� 0 projectname projectName > m     C C�null     ߀��  	�
Finder.app��0� ����� 2����` ޠ ��(   )        (�� ��߀ �MACS   alis    Z  Main                       ��&NH+    	�
Finder.app                                                       2T���K        ����  	                CoreServices    ��^�      ���      	�  	�  	�  +Main:System:Library:CoreServices:Finder.app    
 F i n d e r . a p p  
  M a i n  &System/Library/CoreServices/Finder.app  / ��   <  D E D l   ������  ��   E  F G F Z    A H I���� H l   " J�� J =    " K L K o     ���� "0 outputdirectory outputDirectory L m     ! M M      ��   I k   % = N N  O P O l  % %�� Q��   Q ; 5 Choose the destination folder for the project files.    P  R S R r   % 2 T U T I  % 0���� V
�� .sysostflalis    ��� null��   V �� W��
�� 
prmp W b   ' , X Y X b   ' * Z [ Z m   ' ( \ \ 2 ,Choose the project folder on Pogo where the     [ o   ( )���� 0 projectname projectName Y m   * + ] ]    scanned images should go:   ��   U o      ���� &0 destinationfolder destinationFolder S  ^�� ^ O   3 = _ ` _ r   7 < a b a n   7 : c d c 1   8 :��
�� 
psxp d o   7 8���� &0 destinationfolder destinationFolder b o      ���� "0 outputdirectory outputDirectory ` m   3 4 C��  ��  ��   G  e f e l  B B������  ��   f  g h g l  B B�� i��   i @ : For each file in this project folder do the following...	    h  j k j X   B � l�� m l k   R � n n  o p o O   R \ q r q r   V [ s t s n   V Y u v u 1   W Y��
�� 
pnam v o   V W���� 0 	imagefile 	imageFile t o      ���� 0 	imagename 	imageName r m   R S C p  w x w l  ] ]������  ��   x  y z y l  ] ]�� {��   { &   Dropcrop the image in Photoshop    z  | } | l  ] ]�� ~��   ~ . (		tell application "Adobe Photoshop 7.0"    }   �  l  ] ]�� ���   �  			try    �  � � � l  ] ]�� ���   � { u				do script "Main:Desktop:dropcropper" with imageFile save and close yes log (alias of "Main:Desktop:dropcrop.err")    �  � � � l  ] ]�� ���   �  			on error    �  � � � l  ] ]�� ���   � * $				set errorCount to errorCount + 1    �  � � � l  ] ]�� ���   � Z T				set errorMessage to errorMessage & "ERROR: Unable to drop crop " & imageName & "    �  � � � l  ] ]�� ���   �  "    �  � � � l  ] ]�� ���   �  
			end try    �  � � � l  ] ]�� ���   �  
		end tell    �  � � � l  ] ]������  ��   �  � � � l  ] ]�� ���   � 6 0 Copy the file to the destination folder on Pogo    �  ��� � O   ] � � � � Q   a � � � � � k   d s � �  � � � I  d m�� � �
�� .coreclon****      � **** � o   d e���� 0 	imagefile 	imageFile � �� � �
�� 
insh � o   f g���� &0 destinationfolder destinationFolder � �� ���
�� 
alrp � m   h i��
�� savoyes ��   �  ��� � r   n s � � � [   n q � � � o   n o���� 0 	copycount 	copyCount � m   o p����  � o      ���� 0 	copycount 	copyCount��   � R      ������
�� .ascrerr ****      � ****��  ��   � k   { � � �  � � � r   { � � � � b   { � � � � b   { � � � � b   { � � � � b   { � � � � b   { � � � � o   { |���� 0 errormessage errorMessage � m   |  � �  ERROR: Unable to copy     � o   � ����� 0 	imagename 	imageName � m   � � � � 
  to     � o   � ����� "0 outputdirectory outputDirectory � m   � � � �  
    � o      ���� 0 errormessage errorMessage �  ��� � r   � � � � � [   � � � � � o   � ����� 0 
errorcount 
errorCount � m   � �����  � o      ���� 0 
errorcount 
errorCount��   � m   ] ^ C��  �� 0 	imagefile 	imageFile m o   E F���� &0 scannedimagefiles scannedImageFiles k  � � � l  � �������  ��   �  � � � l  � ��� ���   � 0 * Display the results of the folder action.    �  � � � r   � � � � � b   � � � � � b   � � � � � b   � � � � � b   � � � � � m   � � � �       � o   � ����� .0 scannedimagefilecount scannedImageFileCount � m   � � � �   items found in the     � o   � ����� 0 projectname projectName � m   � � � �  	 folder.
    � o      ����  0 resultsmessage resultsMessage �  � � � r   � � � � � b   � � � � � b   � � � � � b   � � � � � b   � � � � � o   � �����  0 resultsmessage resultsMessage � o   � ����� 0 	copycount 	copyCount � m   � � � � $  files successfully copied to     � o   � ����� "0 outputdirectory outputDirectory � m   � � � �  	 folder.
    � o      ����  0 resultsmessage resultsMessage �  � � � Z   � � � ����� � l  � � ��� � >   � � � � � o   � ����� 0 
errorcount 
errorCount � m   � �����  ��   � k   � � � �  � � � r   � � � � � b   � � � � � b   � � � � � b   � � � � � o   � �����  0 resultsmessage resultsMessage � m   � � � �  There were     � o   � ����� 0 
errorcount 
errorCount � m   � � � �  	 errors:
    � o      ����  0 resultsmessage resultsMessage �  ��� � r   � � � � � b   � � �  � o   � �����  0 resultsmessage resultsMessage  o   � ����� 0 errormessage errorMessage � o      ����  0 resultsmessage resultsMessage��  ��  ��   � �� I  � ���
�� .sysodlogaskr        TEXT o   � �����  0 resultsmessage resultsMessage ��
�� 
btns J   � � �� m   � �  OK   ��   ��	��
�� 
dflt	 m   � ����� ��  ��  ��       ��
��  
 ���
�� .facofgetnull���     alis
� .aevtoappnull  �   � **** �~ �}�|�{
�~ .facofgetnull���     alis�} 0 projectfolder projectFolder�| �z�y�x
�z 
flst�y &0 scannedimagefiles scannedImageFiles�x   �w�v�u�t�s�r�q�p�o�n�m�l�w 0 projectfolder projectFolder�v &0 scannedimagefiles scannedImageFiles�u .0 scannedimagefilecount scannedImageFileCount�t 0 	copycount 	copyCount�s 0 
errorcount 
errorCount�r 0 errormessage errorMessage�q 0 projectname projectName�p "0 outputdirectory outputDirectory�o &0 destinationfolder destinationFolder�n 0 	imagefile 	imageFile�m 0 	imagename 	imageName�l  0 resultsmessage resultsMessage !�k 8 C�j M�i \ ]�h�g�f�e�d�c�b�a�`�_�^ � � � � � � � � � ��]�\�[
�k .corecnte****       ****
�j 
pnam
�i 
prmp
�h .sysostflalis    ��� null
�g 
psxp
�f 
kocl
�e 
cobj
�d 
insh
�c 
alrp
�b savoyes �a 
�` .coreclon****      � ****�_  �^  
�] 
btns
�\ 
dflt
�[ .sysodlogaskr        TEXT�{ ��j  E�OjE�OjE�O�E�O� ��,E�UO��  *��%�%l E�O� ��,E�UY hO W�[��l  kh 	� ��,E�UO� 5 ����� O�kE�W  X  �a %�%a %�%a %E�O�kE�U[OY��Oa �%a %�%a %E�O��%a %�%a %E�O�j �a %�%a %E�O��%E�Y hO�a a kva k�   �Z�Y�X�W
�Z .aevtoappnull  �   � **** k       �V�V  �Y  �X      �U�T
�U 
ctxt�T "0 outputdirectory outputDirectory�W ��&E� ascr  ��ޭ