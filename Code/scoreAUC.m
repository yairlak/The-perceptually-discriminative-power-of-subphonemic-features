 
 function auc = scoreAUC(labels,scores)
% auc = scoreAUC(labels,scores)
% N x 1 boolean labels
% N x 1 scores
%
% http://www.springerlink.com/content/nn141j42838n7u21/fulltext.pdf

assert( islogical(labels) ,'labels input should be logical');
assert( isequal(size(labels),size(scores)) ,'labels and scores should have the same size');

[n,m] = size(labels);
assert( m==1, 'should have sizse of (n,1)');

num_pos = sum(labels);
num_neg = n - num_pos;
assert( ~(num_pos==0), 'no positive labels entered');
assert( ~(num_pos==n), 'no negative labels entered');


ranks = tiedrank(scores);
auc = ( sum( ranks(labels) ) - num_pos * (num_pos+1)/2) / ( num_pos * num_neg);

end