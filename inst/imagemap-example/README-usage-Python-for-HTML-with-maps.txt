You can create an HTML with the image map for each subject and chromosome
using toMap.py. You will need to have toMap.py and toMapMod.py accessible
from the place where you will call them.

Suppose you have created th pngs and associated files in directory d1. The
easiest would be to copy toMapMod.py and toMap.py there. Then, for
instance, for Chr1 and subject L.1 do

./toMap.py Chr1@L.1 ug Hs

where the first argument is the root name of the png file, the second is
the type of identifier (unigene, for this call) and the third is organism
(Home sapiens in this call).  Those two arguments are used to link to the
Toronto Database of Genomic Variants and IDClight.

You could easily create a script (in R, in Python, in the shell, etc) to
loop over all Chr and all subjects.


For instance, from within R, if you are interested in chromosomes 1 to 3
for subjects L.1, L3, and m6, do

chromosomes <- rep(1:3, 3)
subjects <- rep(c("L.1", "L3", "m6"), rep(3, 3))

python.calls <- paste("./toMap.py ", "Chr", chromosomes, 
                      "@", subjects, " ug", " Hs ", sep = "")

sapply(python.calls, function(x) system(x))


and that will create nine HTML files.
