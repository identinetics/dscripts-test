import os
import pytest
import shutil
import tag_build

testdatadir = 'tests/testdata/tag_build/test01/'
testout = 'tests/testout/'

@pytest.fixture
def expected_input_01():
    shutil.rmtree(testout, ignore_errors=True)
    shutil.copytree(testdatadir + 'fixture', testout)

def test_01(expected_input_01):
    print('start test')
    tag_build.main(testout + 'manifest/manifest.tmp', 'global', '621af6941e30',  '-d', '-T')
