# C runtime startoff
#  sccs id   @(#)crt0.s	35.1 5/6/81

	.set	exit,1
.globl	_exit
.globl	start
.globl	_main
.globl	_environ
.globl	_xports
.globl _gstart
.globl _proflush
.globl _holbeg
.globl _holend
.globl Fixzero


#
#	C language startup routine
#
#	special 512 byte area for nil (and possibly other atoms)
#	and special block of smallnums.
#
	.long	0
	.long	0
	.long	0
	.long	-4
	.long	20
	.byte	'n,'i,'l,0
	.long	0
	.long	0
	.long	-4
	.long	40
	.byte	'e,'o,'f,0
	.space 512-44
_xports:
	.long	__iob+0
	.long	__iob+16
	.long	__iob+32
	.long	__iob+48
	.long	__iob+64
	.long	__iob+80
	.long	__iob+96
	.long	__iob+112
	.long	__iob+128
	.long	__iob+144
	.long	__iob+160
	.long	__iob+176
	.long	__iob+192
	.long	__iob+208
	.long	__iob+224
	.long	__iob+240
	.long	__iob+256
	.long	__iob+272
	.long	__iob+288
	.long	__iob+304
	.space	512 - (20 * 4)
	.long	-1024,-1023,-1022,-1021,-1020,-1019,-1018,-1017
	.long	-1016,-1015,-1014,-1013,-1012,-1011,-1010,-1009
	.long	-1008,-1007,-1006,-1005,-1004,-1003,-1002,-1001
	.long	-1000,-999,-998,-997,-996,-995,-994,-993
	.long	-992,-991,-990,-989,-988,-987,-986,-985
	.long	-984,-983,-982,-981,-980,-979,-978,-977
	.long	-976,-975,-974,-973,-972,-971,-970,-969
	.long	-968,-967,-966,-965,-964,-963,-962,-961
	.long	-960,-959,-958,-957,-956,-955,-954,-953
	.long	-952,-951,-950,-949,-948,-947,-946,-945
	.long	-944,-943,-942,-941,-940,-939,-938,-937
	.long	-936,-935,-934,-933,-932,-931,-930,-929
	.long	-928,-927,-926,-925,-924,-923,-922,-921
	.long	-920,-919,-918,-917,-916,-915,-914,-913
	.long	-912,-911,-910,-909,-908,-907,-906,-905
	.long	-904,-903,-902,-901,-900,-899,-898,-897
	.long	-896,-895,-894,-893,-892,-891,-890,-889
	.long	-888,-887,-886,-885,-884,-883,-882,-881
	.long	-880,-879,-878,-877,-876,-875,-874,-873
	.long	-872,-871,-870,-869,-868,-867,-866,-865
	.long	-864,-863,-862,-861,-860,-859,-858,-857
	.long	-856,-855,-854,-853,-852,-851,-850,-849
	.long	-848,-847,-846,-845,-844,-843,-842,-841
	.long	-840,-839,-838,-837,-836,-835,-834,-833
	.long	-832,-831,-830,-829,-828,-827,-826,-825
	.long	-824,-823,-822,-821,-820,-819,-818,-817
	.long	-816,-815,-814,-813,-812,-811,-810,-809
	.long	-808,-807,-806,-805,-804,-803,-802,-801
	.long	-800,-799,-798,-797,-796,-795,-794,-793
	.long	-792,-791,-790,-789,-788,-787,-786,-785
	.long	-784,-783,-782,-781,-780,-779,-778,-777
	.long	-776,-775,-774,-773,-772,-771,-770,-769
	.long	-768,-767,-766,-765,-764,-763,-762,-761
	.long	-760,-759,-758,-757,-756,-755,-754,-753
	.long	-752,-751,-750,-749,-748,-747,-746,-745
	.long	-744,-743,-742,-741,-740,-739,-738,-737
	.long	-736,-735,-734,-733,-732,-731,-730,-729
	.long	-728,-727,-726,-725,-724,-723,-722,-721
	.long	-720,-719,-718,-717,-716,-715,-714,-713
	.long	-712,-711,-710,-709,-708,-707,-706,-705
	.long	-704,-703,-702,-701,-700,-699,-698,-697
	.long	-696,-695,-694,-693,-692,-691,-690,-689
	.long	-688,-687,-686,-685,-684,-683,-682,-681
	.long	-680,-679,-678,-677,-676,-675,-674,-673
	.long	-672,-671,-670,-669,-668,-667,-666,-665
	.long	-664,-663,-662,-661,-660,-659,-658,-657
	.long	-656,-655,-654,-653,-652,-651,-650,-649
	.long	-648,-647,-646,-645,-644,-643,-642,-641
	.long	-640,-639,-638,-637,-636,-635,-634,-633
	.long	-632,-631,-630,-629,-628,-627,-626,-625
	.long	-624,-623,-622,-621,-620,-619,-618,-617
	.long	-616,-615,-614,-613,-612,-611,-610,-609
	.long	-608,-607,-606,-605,-604,-603,-602,-601
	.long	-600,-599,-598,-597,-596,-595,-594,-593
	.long	-592,-591,-590,-589,-588,-587,-586,-585
	.long	-584,-583,-582,-581,-580,-579,-578,-577
	.long	-576,-575,-574,-573,-572,-571,-570,-569
	.long	-568,-567,-566,-565,-564,-563,-562,-561
	.long	-560,-559,-558,-557,-556,-555,-554,-553
	.long	-552,-551,-550,-549,-548,-547,-546,-545
	.long	-544,-543,-542,-541,-540,-539,-538,-537
	.long	-536,-535,-534,-533,-532,-531,-530,-529
	.long	-528,-527,-526,-525,-524,-523,-522,-521
	.long	-520,-519,-518,-517,-516,-515,-514,-513
	.long	-512,-511,-510,-509,-508,-507,-506,-505
	.long	-504,-503,-502,-501,-500,-499,-498,-497
	.long	-496,-495,-494,-493,-492,-491,-490,-489
	.long	-488,-487,-486,-485,-484,-483,-482,-481
	.long	-480,-479,-478,-477,-476,-475,-474,-473
	.long	-472,-471,-470,-469,-468,-467,-466,-465
	.long	-464,-463,-462,-461,-460,-459,-458,-457
	.long	-456,-455,-454,-453,-452,-451,-450,-449
	.long	-448,-447,-446,-445,-444,-443,-442,-441
	.long	-440,-439,-438,-437,-436,-435,-434,-433
	.long	-432,-431,-430,-429,-428,-427,-426,-425
	.long	-424,-423,-422,-421,-420,-419,-418,-417
	.long	-416,-415,-414,-413,-412,-411,-410,-409
	.long	-408,-407,-406,-405,-404,-403,-402,-401
	.long	-400,-399,-398,-397,-396,-395,-394,-393
	.long	-392,-391,-390,-389,-388,-387,-386,-385
	.long	-384,-383,-382,-381,-380,-379,-378,-377
	.long	-376,-375,-374,-373,-372,-371,-370,-369
	.long	-368,-367,-366,-365,-364,-363,-362,-361
	.long	-360,-359,-358,-357,-356,-355,-354,-353
	.long	-352,-351,-350,-349,-348,-347,-346,-345
	.long	-344,-343,-342,-341,-340,-339,-338,-337
	.long	-336,-335,-334,-333,-332,-331,-330,-329
	.long	-328,-327,-326,-325,-324,-323,-322,-321
	.long	-320,-319,-318,-317,-316,-315,-314,-313
	.long	-312,-311,-310,-309,-308,-307,-306,-305
	.long	-304,-303,-302,-301,-300,-299,-298,-297
	.long	-296,-295,-294,-293,-292,-291,-290,-289
	.long	-288,-287,-286,-285,-284,-283,-282,-281
	.long	-280,-279,-278,-277,-276,-275,-274,-273
	.long	-272,-271,-270,-269,-268,-267,-266,-265
	.long	-264,-263,-262,-261,-260,-259,-258,-257
	.long	-256,-255,-254,-253,-252,-251,-250,-249
	.long	-248,-247,-246,-245,-244,-243,-242,-241
	.long	-240,-239,-238,-237,-236,-235,-234,-233
	.long	-232,-231,-230,-229,-228,-227,-226,-225
	.long	-224,-223,-222,-221,-220,-219,-218,-217
	.long	-216,-215,-214,-213,-212,-211,-210,-209
	.long	-208,-207,-206,-205,-204,-203,-202,-201
	.long	-200,-199,-198,-197,-196,-195,-194,-193
	.long	-192,-191,-190,-189,-188,-187,-186,-185
	.long	-184,-183,-182,-181,-180,-179,-178,-177
	.long	-176,-175,-174,-173,-172,-171,-170,-169
	.long	-168,-167,-166,-165,-164,-163,-162,-161
	.long	-160,-159,-158,-157,-156,-155,-154,-153
	.long	-152,-151,-150,-149,-148,-147,-146,-145
	.long	-144,-143,-142,-141,-140,-139,-138,-137
	.long	-136,-135,-134,-133,-132,-131,-130,-129
	.long	-128,-127,-126,-125,-124,-123,-122,-121
	.long	-120,-119,-118,-117,-116,-115,-114,-113
	.long	-112,-111,-110,-109,-108,-107,-106,-105
	.long	-104,-103,-102,-101,-100,-99,-98,-97
	.long	-96,-95,-94,-93,-92,-91,-90,-89
	.long	-88,-87,-86,-85,-84,-83,-82,-81
	.long	-80,-79,-78,-77,-76,-75,-74,-73
	.long	-72,-71,-70,-69,-68,-67,-66,-65
	.long	-64,-63,-62,-61,-60,-59,-58,-57
	.long	-56,-55,-54,-53,-52,-51,-50,-49
	.long	-48,-47,-46,-45,-44,-43,-42,-41
	.long	-40,-39,-38,-37,-36,-35,-34,-33
	.long	-32,-31,-30,-29,-28,-27,-26,-25
	.long	-24,-23,-22,-21,-20,-19,-18,-17
	.long	-16,-15,-14,-13,-12,-11,-10,-9
	.long	-8,-7,-6,-5,-4,-3,-2,-1
Fixzero:
	.long	0,1,2,3,4,5,6,7
	.long	8,9,10,11,12,13,14,15
	.long	16,17,18,19,20,21,22,23
	.long	24,25,26,27,28,29,30,31
	.long	32,33,34,35,36,37,38,39
	.long	40,41,42,43,44,45,46,47
	.long	48,49,50,51,52,53,54,55
	.long	56,57,58,59,60,61,62,63
	.long	64,65,66,67,68,69,70,71
	.long	72,73,74,75,76,77,78,79
	.long	80,81,82,83,84,85,86,87
	.long	88,89,90,91,92,93,94,95
	.long	96,97,98,99,100,101,102,103
	.long	104,105,106,107,108,109,110,111
	.long	112,113,114,115,116,117,118,119
	.long	120,121,122,123,124,125,126,127
	.long	128,129,130,131,132,133,134,135
	.long	136,137,138,139,140,141,142,143
	.long	144,145,146,147,148,149,150,151
	.long	152,153,154,155,156,157,158,159
	.long	160,161,162,163,164,165,166,167
	.long	168,169,170,171,172,173,174,175
	.long	176,177,178,179,180,181,182,183
	.long	184,185,186,187,188,189,190,191
	.long	192,193,194,195,196,197,198,199
	.long	200,201,202,203,204,205,206,207
	.long	208,209,210,211,212,213,214,215
	.long	216,217,218,219,220,221,222,223
	.long	224,225,226,227,228,229,230,231
	.long	232,233,234,235,236,237,238,239
	.long	240,241,242,243,244,245,246,247
	.long	248,249,250,251,252,253,254,255
	.long	256,257,258,259,260,261,262,263
	.long	264,265,266,267,268,269,270,271
	.long	272,273,274,275,276,277,278,279
	.long	280,281,282,283,284,285,286,287
	.long	288,289,290,291,292,293,294,295
	.long	296,297,298,299,300,301,302,303
	.long	304,305,306,307,308,309,310,311
	.long	312,313,314,315,316,317,318,319
	.long	320,321,322,323,324,325,326,327
	.long	328,329,330,331,332,333,334,335
	.long	336,337,338,339,340,341,342,343
	.long	344,345,346,347,348,349,350,351
	.long	352,353,354,355,356,357,358,359
	.long	360,361,362,363,364,365,366,367
	.long	368,369,370,371,372,373,374,375
	.long	376,377,378,379,380,381,382,383
	.long	384,385,386,387,388,389,390,391
	.long	392,393,394,395,396,397,398,399
	.long	400,401,402,403,404,405,406,407
	.long	408,409,410,411,412,413,414,415
	.long	416,417,418,419,420,421,422,423
	.long	424,425,426,427,428,429,430,431
	.long	432,433,434,435,436,437,438,439
	.long	440,441,442,443,444,445,446,447
	.long	448,449,450,451,452,453,454,455
	.long	456,457,458,459,460,461,462,463
	.long	464,465,466,467,468,469,470,471
	.long	472,473,474,475,476,477,478,479
	.long	480,481,482,483,484,485,486,487
	.long	488,489,490,491,492,493,494,495
	.long	496,497,498,499,500,501,502,503
	.long	504,505,506,507,508,509,510,511
	.long	512,513,514,515,516,517,518,519
	.long	520,521,522,523,524,525,526,527
	.long	528,529,530,531,532,533,534,535
	.long	536,537,538,539,540,541,542,543
	.long	544,545,546,547,548,549,550,551
	.long	552,553,554,555,556,557,558,559
	.long	560,561,562,563,564,565,566,567
	.long	568,569,570,571,572,573,574,575
	.long	576,577,578,579,580,581,582,583
	.long	584,585,586,587,588,589,590,591
	.long	592,593,594,595,596,597,598,599
	.long	600,601,602,603,604,605,606,607
	.long	608,609,610,611,612,613,614,615
	.long	616,617,618,619,620,621,622,623
	.long	624,625,626,627,628,629,630,631
	.long	632,633,634,635,636,637,638,639
	.long	640,641,642,643,644,645,646,647
	.long	648,649,650,651,652,653,654,655
	.long	656,657,658,659,660,661,662,663
	.long	664,665,666,667,668,669,670,671
	.long	672,673,674,675,676,677,678,679
	.long	680,681,682,683,684,685,686,687
	.long	688,689,690,691,692,693,694,695
	.long	696,697,698,699,700,701,702,703
	.long	704,705,706,707,708,709,710,711
	.long	712,713,714,715,716,717,718,719
	.long	720,721,722,723,724,725,726,727
	.long	728,729,730,731,732,733,734,735
	.long	736,737,738,739,740,741,742,743
	.long	744,745,746,747,748,749,750,751
	.long	752,753,754,755,756,757,758,759
	.long	760,761,762,763,764,765,766,767
	.long	768,769,770,771,772,773,774,775
	.long	776,777,778,779,780,781,782,783
	.long	784,785,786,787,788,789,790,791
	.long	792,793,794,795,796,797,798,799
	.long	800,801,802,803,804,805,806,807
	.long	808,809,810,811,812,813,814,815
	.long	816,817,818,819,820,821,822,823
	.long	824,825,826,827,828,829,830,831
	.long	832,833,834,835,836,837,838,839
	.long	840,841,842,843,844,845,846,847
	.long	848,849,850,851,852,853,854,855
	.long	856,857,858,859,860,861,862,863
	.long	864,865,866,867,868,869,870,871
	.long	872,873,874,875,876,877,878,879
	.long	880,881,882,883,884,885,886,887
	.long	888,889,890,891,892,893,894,895
	.long	896,897,898,899,900,901,902,903
	.long	904,905,906,907,908,909,910,911
	.long	912,913,914,915,916,917,918,919
	.long	920,921,922,923,924,925,926,927
	.long	928,929,930,931,932,933,934,935
	.long	936,937,938,939,940,941,942,943
	.long	944,945,946,947,948,949,950,951
	.long	952,953,954,955,956,957,958,959
	.long	960,961,962,963,964,965,966,967
	.long	968,969,970,971,972,973,974,975
	.long	976,977,978,979,980,981,982,983
	.long	984,985,986,987,988,989,990,991
	.long	992,993,994,995,996,997,998,999
	.long	1000,1001,1002,1003,1004,1005,1006,1007
	.long	1008,1009,1010,1011,1012,1013,1014,1015
	.long	1016,1017,1018,1019,1020,1021,1022,1023

start:
	.word	0x0000
	subl2	$8,sp
	movl	8(sp),(sp)  #  argc
	movab	12(sp),r0
	movl	r0,4(sp)  #  argv
L1:
	tstl	(r0)+  #  null args term ?
	bneq	L1
	cmpl	r0,*4(sp)  #  end of 'env' or 'argv' ?
	blss	L2
	tstl	-(r0)  # envp's are in list
L2:
	movl	r0,8(sp)  #  env
#	movl	r0,_environ  #  indir is 0 if no env ; not 0 if env
	calls	$3,_main
	pushl	r0
	calls	$1,_exit
	chmk	$exit
_gstart:
	.word	0
	moval	start,r0
	ret
_proflush:
	.word	0
	ret
#
	.data
_holbeg:			# dummy locations
_holend:
_environ:	.space	4
