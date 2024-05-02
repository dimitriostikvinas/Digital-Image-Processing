
img_1 = imread('text1.png');
fileID_1 = fopen('text1.txt','r');

N1 = 250;
N2 = 250;
N3 = 250;
K1 = 5;
K2 = 3;
K3 = 3;
[Mdl_1, Mdl_2, Mdl_3, weightedAccuracies_validation, ...
   weightedAccuracies_train, C_Matrices_validation, C_Matrices_train, ...
   height_letters_training, width_letters_training] = KNNClassifiers(img_1, fileID_1, N1, N2, N3, K1, K2, K3);
 
fclose(fileID_1);
img_2 = imread('text2.png');
fileID_2 = fopen('text2.txt','r');
[lines, text, C_Matrices, weightedAccuracies] = readtext(img_2, fileID_2, Mdl_1, Mdl_2, Mdl_3, ...
  N1, N2, N3, height_letters_training, width_letters_training);

fclose(fileID_2);
