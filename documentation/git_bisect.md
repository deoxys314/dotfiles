# Git Bisect

1. Find a good commit, note the hash or tag or some identifier.
2. Find a bad commit, note the hash or tag or some identifier.
3. Enter bisect mode using `$ git bisect`.
4. Tell bisect the good pr bad commits with `$ git bisect good abcdef` and `$
   git bisect bad 123456`.
5. Then tell git which of each commit is good based with `$ git bisect
   good|bad`. Git will automatically narrow down the range for you.
