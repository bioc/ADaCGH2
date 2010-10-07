#!/usr/bin/python
import sys
import os
from toMapMod import *

nameMap  = sys.argv[1]
idtype   = sys.argv[2]
organism = sys.argv[3]

print nameMap
## work_dir = sys.argv[4]

nameSrc = nameMap + '.png'
nameHTML = nameMap + '.html'

## os.chdir(work_dir)

gene_F = open('geneNames_' + nameMap, mode = 'r')
gene_Names = [L.rstrip('\n') for L in gene_F]
gene_F.close()
map_F = open('pngCoord_' + nameMap, mode = 'r')
map_coord = [L.rstrip('\n') for L in map_F]
map_F.close()

if organism == 'Hs':
    chrom = nameMap[3:nameMap.find('@')]
    ## FIXME: what about X and Y??
    if chrom == '23': chrom = 'X'
    if chrom == '24': chrom = 'Y'
    toronto_db_link = '<p><a href="http://projects.tcag.ca/variation/cgi-bin/tbrowse/tbrowse?source=hg18&table=Locus&show=table&keyword=&flop=AND&fcol=_C19&fcomp==&rnum=0&fkwd=chr' + \
                      chrom + '&cols=">Toronto Database of Genomic Variants link</a></p> <br />\n'
else:
    toronto_db_link = '<p></p><br />'

outList = []
outList.append(out_squeleton1)
outList.append(create_div(gene_Names))
outList.append(out_squeleton2)

outList.append(''.join(['<h1>Chromosome view: ', nameMap, '</h1>\n',
                        toronto_db_link,
                        '<img src="', nameSrc, '"usemap="#', nameMap, '" ISMAP>\n',
                        '<map name="', nameMap, '">\n']))
    

if idtype == 'None' or organism == 'None':
    outList.append(create_map_none(gene_Names, map_coord, idtype, organism))
else:
    outList.append(create_map(gene_Names, map_coord, idtype, organism))

outList.append(['</map> </body> </html>'])


fileout = nameHTML
fout = open(fileout, mode = 'w')
for nl in range(len(outList)):
    fout.writelines(outList[nl])
fout.close()

