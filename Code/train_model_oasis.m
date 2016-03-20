function model  = train_model_oasis(data, similarity_mat, parms)
% model = oasis(data, class_labels, parms)
%
% Code version 1.2 May 2011.
% 
%  Input:
%   -- data         - Nxd sparse matrix (each instance being a ROW)
%   -- distance_matrix - label of each data point  (Nx1 integer vector)
%   -- parms (do sym, do_psd, aggress etc.)
% 
%  Output: 
%   -- model.W - dxd matrix
%   -- model.loss_steps - a binary vector: was there an update at
%         each iterations
%   -- model.parms, the actual parameters used in the run (inc. defaults)
% 
%  Parameters:
%   -- aggress: The cutoff point on the size of the correction
%         (default 0.1) 
%   -- rseed: The random seed for data point selection 
%         (default 1)
%   -- do_sym: Whether to symmetrize the matrix every k steps
%         (default 0)
%   -- do_psd: Whether to PSD the matrix every k steps, including
%         symmetrizing them (defalut 0)
%   -- do_save: Whether to save the intermediate matrices. Note that
%         saving is before symmetrizing and/or PSD in case they exist
%         (default 0)
%   -- save_path: In case do_save==1 a filename is needed, the
%         format is save_path/part_k.mat
%   -- num_steps - Number of total steps the algorithm will
%         run (default 1M steps)
%   -- save_every: Number of steps between each save point
%         (default num_steps/10)
%   -- sym_every: An integer multiple of "save_every",
%         indicates the frequency of symmetrizing in case do_sym=1. The
%         end step will also be symmetrized. (default 1)
%   -- psd_every: An integer multiple of "save_every",
%         indicates the frequency of projecting on PSD cone in case
%         do_psd=1. The end step will also be PSD. (default 1)
%   -- use_matlab: Use oasis_m.m instead of oasis_c.c
%      This is provided in the case of compilation problems.
% 
%
% See Chechik et al. Large scale online learning of image
% similarity through ranking, J. Machine learning Research 2010.
% 
% (C) 2008-2010 Gal Chechik, Yair Lakretz. 

  [N,dim] = size(data);
  W = eye(dim);
  
  % Initialize
  aggress = take_from_struct(parms, 'oasis_aggress', 0.1);
  rseed = take_from_struct(parms, 'rseed', 1);
  num_steps = take_from_struct(parms, 'oasis_num_steps');
  do_sym = take_from_struct(parms, 'do_sym', 0);
  sym_every = take_from_struct(parms, 'sym_every', 1);
  do_psd = take_from_struct(parms, 'do_psd', 0);
  psd_every = take_from_struct(parms, 'psd_every', 1);  
%   do_save = take_from_struct(parms, 'do_save', 1);

  rng(rseed); %ok 
  
  % Optimize 
  loss_steps = zeros(1, num_steps);

  data = full(data);
  [W,loss_steps, loss_iter] = oasis_m_phonemes(data, similarity_mat, W, num_steps, aggress);     
  if do_sym
      if (mod(i_batch,sym_every) == 0) || i_batch == num_batches
        W = 0.5*(W+W');
      end
  end
  if do_psd
%       if (mod(i_batch,psd_every) == 0) || i_batch == num_batches
        [V,D] = eig(0.5*(W+W'));
        W = V*max(D,0)*V';
        clear V D;
%       end
  end

  model.W = W; 
  model.loss_steps = loss_steps;
  model.loss  = loss_iter;
  model.parms = parms;
  
end


function  [W,loss_steps, loss_iter] = oasis_m_phonemes(data, similarity_mat, W, num_steps, aggress)  

% See Chechik et al. Large scale online learning of image
% similarity through ranking, J. Machine learning Research 2010. 
% 
%%

  loss_steps  = zeros(num_steps,1);
  num_objects = size(data, 1);
  if size(data,1) ~= num_objects
    error('dimension mismatch');
  end
  if size(W,1) ~= size(data,2)
    error('dimension mismatch');
  end
  
  %% Prepare indices for all triplets to calculate overall loss (only for small data)
  triplets = zeros(num_objects * nchoosek(num_objects - 1, 2), 3);
  for i = 1:num_objects
      others = setdiff(1:num_objects, i, 'stable');
      pairs  = nchoosek(1:(num_objects - 1), 2);
      others = others(pairs);
      
      st = 1 + (i-1)*nchoosek(num_objects - 1, 2);
      ed = i * nchoosek(num_objects - 1, 2);
      triplets(st:ed, 1)   = i;
      triplets(st:ed, 2:3) = others;  
  end
  
  for i = 1:size(triplets, 1)
      if similarity_mat(triplets(i, 2)) < similarity_mat(triplets(i, 3))
          tmp = triplets(i, 2); triplets(i, 2) = triplets(i, 3); triplets(i, 3) = tmp;
      end
  end
  
  %
  p_all      = data(triplets(:, 1), :);
  p_pos_all  = data(triplets(:, 2), :);
  p_neg_all = data(triplets(:, 3), :);
  
  %%
  loss_iter = [];
  fprintf('iteration number')
  for i_iter = 1: num_steps;    
    % Calc overall loss:
    if mod(i_iter, 100) == 1
        fprintf('%i...', i_iter)
    end
    if mod(i_iter, 5) == 1 
        similarity2pos = p_all * W * p_pos_all';
        similarity2pos = diag(similarity2pos);
        similarity2neg = p_all * W * p_neg_all';
        similarity2neg = diag(similarity2neg);
        l_W = max([zeros(length(similarity2neg), 1), 1 - similarity2pos + similarity2neg], [], 2);
        loss_iter(i_iter) = sum(l_W);
        clear similarity2neg similarity2pos 
    end
    
    % Sample a phoneme:
    p_ind     = ceil(rand(1)*num_objects);
    pos_ind   = ceil(rand(1)*num_objects);
    neg_ind   = ceil(rand(1)*num_objects);
    
    while p_ind == pos_ind || p_ind == neg_ind || pos_ind == neg_ind || ...
            similarity_mat(p_ind, pos_ind) == similarity_mat(p_ind, neg_ind)
        pos_ind   = ceil(rand(1)*num_objects);
        neg_ind   = ceil(rand(1)*num_objects);
    end
    
    if similarity_mat(p_ind, pos_ind) < similarity_mat(p_ind, neg_ind)
            tmp = pos_ind; pos_ind = neg_ind; neg_ind = tmp;
    end
    
    % loss
    p   = data(p_ind,:);
    samples_delta = [+1, -1] * data([pos_ind, neg_ind],:);
    
    loss = 1 - p*W*samples_delta';
    
    if loss > 0 % Update W

        grad_W = p'*samples_delta;
        loss_steps(i_iter) = 1;

        norm_grad_W = sum(p .* p) * sum(samples_delta .*samples_delta);

        % constraint on the maximal update step size
        tau_val = loss/norm_grad_W; %loss / (V*V');
        tau = min(aggress, tau_val); 
        
        W = W + tau*grad_W;
        
     end
  end

  loss_steps = sparse(loss_steps);
end
