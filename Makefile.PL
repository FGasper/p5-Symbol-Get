

use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME         => 'Symbol::Get',
    VERSION_FROM => 'lib/Symbol/Get.pm', # finds \$VERSION
    AUTHOR       => 'Felipe Gasper (FELIPE)',
    ABSTRACT_FROM  => 'lib/Symbol/Get.pm',
    META_MERGE => {
        'meta-spec' => { version => 2 },
         resources => {
             repository => {
                 type => 'git',
                 url  => 'https://github.com/FGasper/p5-Symbol-Get.git',
                 web  => 'https://github.com/FGasper/p5-Symbol-Get',
             },
         },
    },
    TEST_REQUIRES    => {
                     'Test::More' => 0.44,
                    },
);
