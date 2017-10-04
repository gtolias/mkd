% Authors: A. Bursuc, G. Tolias, H. Jegou. 2015. 

function res = eval_brown (x, pairs)

  idx1 = pairs(:, 1) + 1;
  id1 = pairs(:, 2);
  idx2 = pairs(:, 4) + 1;
  id2 = pairs(:, 5);   
  label = (id1 == id2);

  xref = x(:, idx1);
  xeval = x(:, idx2);

  [~, ranks] = sort(sum(xeval.*xref), 'descend'); % 
  label_ranked = label(ranks);

  tpr = cumsum(label_ranked) / sum(label_ranked);
  fpr = cumsum(~label_ranked) / sum(~label_ranked);

  % area under curve
  auc = trapz(fpr, tpr);

  % FPR @ 95% Recall
  idx_recall95 = find(tpr >= 0.95, 1, 'first');
  fpr95 = fpr(idx_recall95);

  res.roc_tpr = tpr;
  res.roc_fpr = fpr;
  res.auc = auc;
  res.fpr_95 = fpr95;
