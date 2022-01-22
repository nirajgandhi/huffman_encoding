%Using Ascending Logic

%%
%p=[0.4 0.2 0.2 0.2] % probabilities of symbols
p=input('Enter probabilities in this way : [x1 x2 x3 x4 ....] : ');
l=length(p);
probabilities=sort(p);

%%
%Check sum of probabilities is 1.
if sum(p)~=1
    error('Check Probabilities. Sum of al probabilities should be 1.');
    %exit
end

%%
%Display probabilities and their indices

for index = 1:l
    % Create a set containing only this codeword
    set_contents{index} = index; % cell array
    % Store the probability associated with this set
    set_probabilities(index) = p(index);
end

disp('-------------------------------------------------------------------------');
disp('The sets of symbols and their probabilities are:')
for set_index = 1:l
    disp([num2str(set_contents{set_index}) , '   ' , num2str(p(set_index))]);
end

%%
%Sorting

[h,index]=sort(p');
disp('The sets and their probabilities (after sorting) are:')
    for set_index = 1:l
        disp([num2str(index(set_index)) , '   ' , num2str(h(set_index))]);
    end

%%
%Create Huffman Table

col=1;
j=1;

while col~=(l-1) %Columns are 1 less from total no. of probabilities. 

    h(1,col+1)=h(1,col)+h(2,col); % 1st row of every column is sum of 1st and 2nd row of previous column

    for raw=2:(l-j)
        h(raw,col+1)=h(raw+1,col);
    end
    
    for raw=1:l
        if h(raw,col+1)==0
             h(raw,col+1)=1;   % Assuming none symbol has probability 0 or 1         
        end
    end
    
    h=sort(h) % Sort ascending order after completion of next Huffman column
    
    j=j+1;
    col=col+1;
end

%%
%Coding

code =  cell(l,l-1) % create cell array

col=l-1;
raw=1;

% Assigning 0 and 1 to 1st and 2nd row of last column
code{raw,col}='0'
code{raw+1,col}='1'

while col~=1
    i=1;
    x=1;
    z=0;

    if (h(raw,col-1) + h(raw+1,col-1))==h(raw,col)
        
            code{raw,col-1}=[code{raw,col}  '0']
            
            code{raw+1,col-1}=[code{raw,col}  '1']
            
            while ~isempty(code{raw+i,col})
                code{raw+1+i,col-1}=code{raw+i,col}
                i=i+1;
            end
        
    else
       
            code{raw,col-1}=[code{raw+1,col}  '0']
           
            code{raw+1,col-1}=[code{raw+1,col}  '1']
            
            while ~isempty(code{raw+x,col})
                code{raw+1+x,col-1}=code{raw+z,col}
                x=x+1;
                z=z+2;
            end
        
    end
     
    col=col-1;
end

%%
%Display codes and indices.

disp('The indices and codes are:')
    for set_index = 1:l
        disp([index(set_index)     code(set_index,1)]);
    end

%%
% Calculate the symbol entropy
entropy = sum(probabilities.*log2(1./probabilities));

% Calculate the average Huffman codeword length
av_length = 0;
index = 1;
    for row=1:l
          av_length = av_length + probabilities(index)*length(code{row,1});
          index=index+1;
    end

disp(['The symbol entropy is:                     ',num2str(entropy)]);
disp(['The average Huffman codeword length is:    ',num2str(av_length)]);
disp(['The Huffman coding rate is:                ',num2str(entropy/av_length)]);