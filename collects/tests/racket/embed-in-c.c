#include "scheme.h"

static int run(Scheme_Env *e, int argc, char *argv[])
{
  Scheme_Object *curout = NULL, *v = NULL, *a[2] = {NULL, NULL};
  Scheme_Config *config = NULL;
  int i;
  mz_jmp_buf * volatile save = NULL, fresh;
  
  MZ_GC_DECL_REG(8);
  MZ_GC_VAR_IN_REG(0, e);
  MZ_GC_VAR_IN_REG(1, curout);
  MZ_GC_VAR_IN_REG(2, save);
  MZ_GC_VAR_IN_REG(3, config);
  MZ_GC_VAR_IN_REG(4, v);
  MZ_GC_ARRAY_VAR_IN_REG(5, a, 2);
  
  MZ_GC_REG();

  scheme_set_collects_path(scheme_make_path(MZ_COLLECTION_PATH));
  scheme_init_collection_paths(e, scheme_null);

  v = scheme_intern_symbol("scheme/base");
  scheme_namespace_require(v);
  
  config = scheme_current_config();
  curout = scheme_get_param(config, MZCONFIG_OUTPUT_PORT);
  
  for (i = 1; i < argc; i++) {
    save = scheme_current_thread->error_buf;
    scheme_current_thread->error_buf = &fresh;
    if (scheme_setjmp(scheme_error_buf)) {
      scheme_current_thread->error_buf = save;
      return -1; /* There was an error */
    } else {
      v = scheme_eval_string(argv[i], e);
      scheme_display(v, curout);
      v = scheme_make_char('\n');
      scheme_display(v, curout);
    }
  }

  /* RESET: */
  e = scheme_basic_env();
  scheme_init_collection_paths(e, scheme_null);
  v = scheme_intern_symbol("scheme/base");
  scheme_namespace_require(v);

  /* read-eval-print loop, uses initial Scheme_Env: */
  a[0] = scheme_intern_symbol("scheme/base");
  a[1] = scheme_intern_symbol("read-eval-print-loop");
  v = scheme_dynamic_require(2, a);
  scheme_apply(v, 0, NULL);
  scheme_current_thread->error_buf = save;
  
  MZ_GC_UNREG();
  
  return 0;
}
  
int main(int argc, char *argv[])
{
  return scheme_main_setup(1, run, argc, argv);
}
