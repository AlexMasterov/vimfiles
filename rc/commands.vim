"---------------------------------------------------------------------------
" Commands

command! -nargs=0 -bar GoldenRatio execute 'vertical resize' &columns * 5 / 8
command! -nargs=0 -bar WordCount echo strchars(join(getline(1, '$')))
