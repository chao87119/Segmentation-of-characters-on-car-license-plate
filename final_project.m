%%
im=cell(1,20);
%f=fspecial('unsharp',0.5);
for i=1:20
    imageName=strcat('0',num2str(i),'.jpg');
    if length(imageName)==6
        imageName=strcat('0','0',num2str(i),'.jpg');
    end      
    im{i} = imread(imageName);
    %im{i}=imfilter(im{i},f);
    %figure,imshow(im{i}),impixelinfo;
end  
%
table={};
pic=struct('BBoxa',{},'BBoxb',{},'BBox',{});
f=fspecial('unsharp',0.5);
for i=1:20
    ii=1;
    p=im{i};
    p=histeq(p);
    p=imfilter(p,f);
    p=im2bw(p,0.5);
    p=bwareaopen(p,160);
    table{i}=p;
    l=regionprops(p);
    %figure,imshow(p)
    %hold on;
    for j=1:length(l)
        if  l(j).BoundingBox(1)>700  && l(j).BoundingBox(2)<800 
            if  l(j).BoundingBox(4)*l(j).BoundingBox(3)>300 && l(j).BoundingBox(4)*l(j).BoundingBox(3)<3600
                if l(j).BoundingBox(4)>25 && l(j).BoundingBox(4)<60
                    if l(j).BoundingBox(3)/l(j).BoundingBox(4)<0.85 && l(j).BoundingBox(3)/l(j).BoundingBox(4)>0.5
                        %rectangle('position',[l(j).BoundingBox],'EdgeColor','r')
                        pic(i).BBoxa{ii}=l(j).BoundingBox;
                        ii=ii+1;
                    elseif l(j).BoundingBox(3)/l(j).BoundingBox(4)>0.1 && l(j).BoundingBox(3)/l(j).BoundingBox(4)<0.35
                        %rectangle('position',[l(j).BoundingBox],'EdgeColor','r')
                        pic(i).BBoxa{ii}=l(j).BoundingBox;
                        ii=ii+1;         
                    else
                    end
                end
            end
        end
    end
end
%
for i=1:20
    ii=1;
    %figure,imshow(table{i})
    %hold on
    for j=1:length(pic(i).BBoxa)
        count=0;
        for k=1:length(pic(i).BBoxa)
            if  (pic(i).BBoxa{k}(1) > (pic(i).BBoxa{j}(1)-330)) && (pic(i).BBoxa{k}(1) < (pic(i).BBoxa{j}(1)+330))
                if (pic(i).BBoxa{k}(2) > (pic(i).BBoxa{j}(2)-60)) && (pic(i).BBoxa{k}(2) < (pic(i).BBoxa{j}(2)+60))
                    count=count+1;
                end
            end
        end
        if count >= 5
           %rectangle('position',[pic(i).BBoxa{j}],'EdgeColor','r') 
           pic(i).BBox{ii}=pic(i).BBoxa{j};
           ii=ii+1;
        end    
    end
end
% 
for i=1:20
    ii=1;
    [r,c]=size(table{i});
    p1=zeros(r,c);
    p1(table{i}==0)=1;
    p1=bwareaopen(p1,160);
    l1=regionprops(p1);
    %figure,imshow(p1)
    %hold on;
    for k=1:length(l1)
        if l1(k).BoundingBox(1)>850 && l1(k).BoundingBox(1)<1851 && l1(k).BoundingBox(2)<800 && l1(k).BoundingBox(2)>83
            if  l1(k).BoundingBox(4)*l1(k).BoundingBox(3)>300 && l1(k).BoundingBox(4)*l1(k).BoundingBox(3)<3600
                if l1(k).BoundingBox(4)>25 && l1(k).BoundingBox(4)<60
                    if l1(k).BoundingBox(3)/l1(k).BoundingBox(4)<0.85 && l1(k).BoundingBox(3)/l1(k).BoundingBox(4)>0.5
                        %rectangle('position',[l1(k).BoundingBox],'EdgeColor','r')
                        pic(i).BBoxb{ii}=l1(k).BoundingBox;
                        ii=ii+1;
                    elseif l1(k).BoundingBox(3)/l1(k).BoundingBox(4)>0.1 && l1(k).BoundingBox(3)/l1(k).BoundingBox(4)<0.35
                        %rectangle('position',[l1(k).BoundingBox],'EdgeColor','r')
                        pic(i).BBoxb{ii}=l1(k).BoundingBox;
                        ii=ii+1;
                    else
                    end
                end
            end
        end
    end
end
%
for i=1:20
    ii=1+length(pic(i).BBox);
    %figure,imshow(table{i})
    %hold on
    for j=1:length(pic(i).BBoxb)
        count=0;
        for k=1:length(pic(i).BBoxb)
            if  (pic(i).BBoxb{k}(1) > (pic(i).BBoxb{j}(1)-330)) && (pic(i).BBoxb{k}(1) < (pic(i).BBoxb{j}(1)+330))
                if (pic(i).BBoxb{k}(2) > (pic(i).BBoxb{j}(2)-60)) && (pic(i).BBoxb{k}(2) < (pic(i).BBoxb{j}(2)+60))
                    count=count+1;
                end
            end
        end
        if count >= 5
           %rectangle('position',[pic(i).BBoxb{j}],'EdgeColor','r')
           pic(i).BBox{ii}=pic(i).BBoxb{j};
           ii=ii+1;
        end    
    end
end
%
fid = fopen('output.txt','w');
%str=[[1 0 0];[0 1 0];[0 0 1];[0 1 1];[1 0 1];[1 1 0];[0.8500 0.3250 0.0980];[1 0 0]];
for m=1:20
    ii=1;
    outputName=strcat('0',num2str(m),'.jpg');
    if length(outputName)==6
        outputName=strcat('0','0',num2str(m),'.jpg');
    end      
    fprintf(fid,'%s\n',outputName);
    %figure,imshow(table{m});
    %hold on
    for len=1:length(pic(m).BBox)
        fig=true;
        for len1=1:length(pic(m).BBox)
            ratio=bboxOverlapRatio(pic(m).BBox{len},pic(m).BBox{len1});
            if ratio>=0.1 && ratio<1
               fig=(pic(m).BBox{len}(3)>=pic(m).BBox{len1}(3));
               break
            end   
        end    
        if fig~=false
           %rectangle('position',[pic(m).BBox{len}],'EdgeColor','r')
           ii=ii+1;
           x1=ceil(pic(m).BBox{len}(1));
           y1=ceil(pic(m).BBox{len}(2));
           x2=x1+pic(m).BBox{len}(3);
           y2=y1+pic(m).BBox{len}(4);
           fprintf(fid,'%d %d %d %d\n',x1,y1,x2,y2);
        end   
    end 
    %plot(c(:,1),c(:,2),'gx','MarkerSize',15,'LineWidth',3)
end
fclose(fid);