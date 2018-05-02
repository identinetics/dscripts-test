from assertNoDiff import assertNoDiff
import logging
import os
import pytest
import shutil
import buildnbr


logging.basicConfig()
logging.getLogger().setLevel(logging.INFO)

testdatadir = 'tests/testdata/buildnbr/'
testout = 'tests/testout/'

def assert_no_diff(test_no, file, subdir):
    assertNoDiff(os.path.join(testdatadir, test_no, 'expected_output'), testout, file, subdir=subdir)

@pytest.fixture
def expected_input_initial_build():
    shutil.rmtree(testout, ignore_errors=True)
    shutil.copytree(testdatadir + 'test01/fixture', testout)

@pytest.fixture
def expected_input_second_build():
    shutil.rmtree(testout, ignore_errors=True)
    shutil.copytree(testdatadir + 'test02/fixture', testout)

def test_01(expected_input_initial_build):
    logging.info('test 01: intialial build, no existing manifest')
    buildnbr.main(testout + 'manifest/manifest.tmp', 'global', testout + 'buildno')
    assert_no_diff('test01', '1.0', 'manifest/global')
    assert_no_diff('test01', '1.0', 'manifest/global/diff')

def test_02(expected_input_second_build):
    logging.info('test 02: second build, global')
    buildnbr.main(testout + 'manifest/manifest.tmp', 'global', testout + 'buildno')
    assert_no_diff('test02', '2.0', 'manifest/global')
    assert_no_diff('test02', '2.0', 'manifest/global/diff')

def test_03(expected_input_second_build):
    logging.info('test 03: second build, local')
    buildnbr.main(testout + 'manifest/manifest.tmp', 'local', testout + 'buildno')
    assert_no_diff('test03', '1.1', 'manifest/local')
    assert_no_diff('test03', '1.1', 'manifest/local/diff')
