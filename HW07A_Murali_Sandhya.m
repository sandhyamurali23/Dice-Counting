function HW07A_Murali_Sandhya()

addpath( '../TEST_IMAGES');

HW07A_Murali_Sandhya_main(input_image);


end

function HW07A_Murali_Sandhya_main(input_image1)

%convert the image to double
input_image=im2double(imread(input_image1));

%counters for counting the dice and the total summation of the dots
count1=0;
count2=0;
count3=0;
count4=0;
count5=0;
count6=0;
countn=0;
sum=0;

%accessing the red channel to remove the red background present in some of
%the images
channel=input_image(:,:,1);

%apply median filter to remove noise
redMF = medfilt2(channel, [2 2]);

%select appropriate threshold and applying graythresh thresholding to
%convert into a black and white image
thresh=graythresh(redMF); 

%convert into black and white image
im_bw=im2bw(redMF,thresh);


%structuring element to perform erosion,opening and closing
structure_ele=strel('disk',5);
str_open=strel('disk',3);
str_close=strel('disk',15);
 
 
%performing morphological opeations such as erosion,closing and opening
%They are used to separate the dice if touching each other
im_erode=imerode(im_bw,structure_ele);
im_close=imclose(im_erode,str_close);
im_open=imopen(im_close,str_open);

%counting the total number of dice
[separations,n_labels]=bwlabel(im_open);
imagesc(separations);
colormap(gray);
pause(3);
disp(n_labels);

%iterate total number of dice
for ii=1:n_labels
    %checks if it represents an individual dice
    region=separations==ii;
    imagesc(region); 
    colormap(gray);
    axis image 
    drawnow;
    
    %draw the region for counting the black dots
    polyXY=regionprops(region,'ConvexHull');
    hold on;
    
    %Determining the set of xs and ys for plotting the hull
    xs=polyXY.ConvexHull(:,1);
    ys=polyXY.ConvexHull(:,2);
 
    %plot the convex hull in magenta color
    plot(xs,ys,'m-','LineWidth',2); 
    
   
    hold off;
    pause(0.5);
    
    %calculate the inverse of the image
    inverse_img=~(region);
   
    %determine the number of points
     [img_inv,count]=bwlabel(inverse_img);
     count=count-1;
     if(count==1)
         count1=count1+1;
     elseif(count==2)
             count2=count2+1;
     elseif(count==3)
         count3=count3+1;
     elseif(count==4)
         count4=count4+1;
     elseif(count==5)
         count5=count5+1;
     elseif(count==6)
         count6=count6+1;
     else
         countn=countn+1;
     end
     
   sum=sum+count;      
     disp(count);
     imagesc(inverse_img);
     pause(2);
end
    
    
imagesc(im_erode);
colormap('gray');


if(countn>0)
n_labels=n_labels-countn;
end
v=['INPUT FILENAME',input_image1];
disp(v);
fprintf('Number of dice is %d\n',n_labels);
fprintf('Number of 1s : %d\n',count1);
fprintf('Number of 2s : %d\n',count2);
fprintf('Number of 3s : %d\n',count3);
fprintf('Number of 4s : %d\n',count4);
fprintf('Number of 5s : %d\n',count5);
fprintf('Number of 6s : %d\n',count6);
fprintf('Number of unknown : %d\n',countn);
fprintf('Total of all dots : %d\n',sum);


end

