/*
  Todo
   - Declare intersection's type
   - Define function d(v)
*/

double jaccard_selector(sparsemat_t* A, int n, ??? intersection) {
  enum MailBoxType{__M1, __M2};
  Selector<2> __selector;

  int n_local_rows = n / n_pes();
  int __P1 = my_pe();
  for (int v = 0; v < n_local_rows; v++) {
    for (int k = A->offset[v]; k < A->offset[v+1]; k++) {
      int u = A->nonzero[k];
      for (int kk = A->offset[v]; kk < A->offset[v+1]; kk++) {
        int v_nonzero = A->nonzero[kk]; if (v_nonzero == u) continue;
        int __P2 = get_remote_pe(u);
        __selector.send(__M1, __P2, [__P1, u, v, v_nonzero]() {
          for (int u_k = A->offset[get_local_index(u)];
               u_k < A->offset[get_local_index(u+n_pes())]; u_k++) {
            if (v_nonzero == A->nonzero[get_local_index(u_k)]) {
              __selector.send(__M2, __P1, [u, v]() {
                intersection[v,u]++;
              });
            }
          }
        });
      }
    }
  }

  __selector.done(__M1);
  barrier();

  for (int v = 0; v < n_local_rows; v++) {
    for (int k = A->offset[v]; k < A->offset[v+1]; k++) {
      int u = A->nonzero[k];
      J[v,u] = intersection[v,u] / (d(v) + d(u) - intersection[v,u]);
    }
  }
}
