package App::sort_by_sorter;

use 5.010001;
use strict;
use warnings;
use Log::ger;

use AppBase::Sort;
use AppBase::Sort::File ();
use Perinci::Sub::Util qw(gen_modified_sub);

# AUTHORITY
# DATE
# DIST
# VERSION

our %SPEC;

gen_modified_sub(
    output_name => 'sort_by_sorter',
    base_name   => 'AppBase::Sort::sort_appbase',
    summary     => 'Sort lines of text by a Sorter module',
    description => <<'MARKDOWN',

This utility lets you sort lines of text using one of the available Sorter::*
perl modules.

MARKDOWN
    add_args    => {
        %AppBase::Sort::File::argspecs_files,
        sorter_module => {
            schema => "perl::sorter::modname_with_optional_args",
            pos => 0,
        },
    },
    delete_args => [qw/ignore_case reverse/],
    modify_args => {
        files => sub {
            my $argspec = shift;
            #delete $argspec->{pos};
            #delete $argspec->{slurpy};
        },
    },
    modify_meta => sub {
        my $meta = shift;

        $meta->{examples} = [
            {
                src_plang => 'bash',
                src => q[ someprog ... | sort-by-sorter date_in_text=reverse,1],
                test => 0,
                'x.doc.show_result' => 0,
            },
        ];
    },
    output_code => sub {
        require Module::Load::Util;

        my %oc_args = @_;

        AppBase::Sort::File::set_source_arg(\%oc_args);
        $oc_args{_gen_sorter} = sub {
            my $gs_args = shift;
            Module::Load::Util::call_module_function_with_optional_args(
                {
                    ns_prefix => 'Sorter',
                    function => 'gen_sorter',
                },
                $gs_args->{sorter_module});
        };
        AppBase::Sort::sort_appbase(%oc_args);
    },
);

1;
# ABSTRACT:
