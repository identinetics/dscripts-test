import difflib, logging, os.path
__author__ = 'r2h2'

def assertNoDiff(old_path, new_path, filename, subdir=None):
    ''' compare old_path/[subdir/]filename with new_path/[subdir/]filename '''
    if subdir is None:
        f_testdata = open(os.path.abspath(os.path.join(old_path, filename)))
        f_work = open(os.path.abspath(os.path.join(new_path, filename)))
    else:
        f_testdata = open(os.path.abspath(os.path.join(old_path, subdir, filename)))
        f_work = open(os.path.abspath(os.path.join(new_path, subdir, filename)))
    diff = difflib.unified_diff(f_work.readlines(), f_testdata.readlines())
    f_work.close()
    f_testdata.close()
    try:
        assert ''.join(diff) == '', "result (%s) is not equal to reference data (%s)" % (f_work.name, f_testdata.name)
    except AssertionError as e:
        logging.error('     result (' + filename + ')is not equal to reference data.')
        logging.debug(e)
        raise

