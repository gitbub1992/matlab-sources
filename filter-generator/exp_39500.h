
// Exponential filter for the frequency 39,5 kHz

#ifndef _EXP395_H__
#define _EXP395_H__


#include "global.h"

const int32_t cos_39500[256]= {
-737,
-1517,
1828,
200,
-1973,
1219,
1095,
-2008,
349,
1755,
-1614,
-595,
2041,
-876,
-1412,
1891,
50,
-1928,
1337,
964,
-2032,
497,
1673,
-1703,
-449,
2024,
-1009,
-1299,
1943,
-101,
-1872,
1447,
829,
-2045,
642,
1582,
-1782,
-301,
1997,
-1138,
-1179,
1985,
-251,
-1806,
1550,
689,
-2047,
783,
1482,
-1851,
-151,
1958,
-1260,
-1053,
2016,
-400,
-1730,
1644,
545,
-2038,
920,
1374,
-1910,
0,
1909,
-1375,
-921,
2037,
-546,
-1645,
1729,
399,
-2017,
1052,
1259,
-1959,
150,
1850,
-1483,
-784,
2046,
-690,
-1551,
1805,
250,
-1986,
1178,
1137,
-1998,
300,
1781,
-1583,
-643,
2044,
-830,
-1448,
1871,
100,
-1944,
1298,
1008,
-2025,
448,
1702,
-1674,
-498,
2031,
-965,
-1338,
1927,
-51,
-1892,
1411,
875,
-2042,
594,
1613,
-1756,
-350,
2007,
-1096,
-1220,
1972,
-201,
-1829,
1516,
736,
-2047,
736,
1516,
-1829,
-201,
1972,
-1220,
-1096,
2007,
-350,
-1756,
1613,
594,
-2042,
875,
1411,
-1892,
-51,
1927,
-1338,
-965,
2031,
-498,
-1674,
1702,
448,
-2025,
1008,
1298,
-1944,
100,
1871,
-1448,
-830,
2044,
-643,
-1583,
1781,
300,
-1998,
1137,
1178,
-1986,
250,
1805,
-1551,
-690,
2046,
-784,
-1483,
1850,
150,
-1959,
1259,
1052,
-2017,
399,
1729,
-1645,
-546,
2037,
-921,
-1375,
1909,
0,
-1910,
1374,
920,
-2038,
545,
1644,
-1730,
-400,
2016,
-1053,
-1260,
1958,
-151,
-1851,
1482,
783,
-2047,
689,
1550,
-1806,
-251,
1985,
-1179,
-1138,
1997,
-301,
-1782,
1582,
642,
-2045,
829,
1447,
-1872,
-101,
1943,
-1299,
-1009,
2024,
-449,
-1703,
1673,
497,
-2032,
964,
1337,
-1928,
50,
1891,
-1412,
-876,
2041,
-595,
-1614,
1755,
349,
-2008,
1095,
1219,
-1973,
200,
1828,
-1517,
-737,
2047,
};
const int32_t sin_39500[256]= {
1909,
-1375,
-921,
2037,
-546,
-1645,
1729,
399,
-2017,
1052,
1259,
-1959,
150,
1850,
-1483,
-784,
2046,
-690,
-1551,
1805,
250,
-1986,
1178,
1137,
-1998,
300,
1781,
-1583,
-643,
2044,
-830,
-1448,
1871,
100,
-1944,
1298,
1008,
-2025,
448,
1702,
-1674,
-498,
2031,
-965,
-1338,
1927,
-51,
-1892,
1411,
875,
-2042,
594,
1613,
-1756,
-350,
2007,
-1096,
-1220,
1972,
-201,
-1829,
1516,
736,
-2047,
736,
1516,
-1829,
-201,
1972,
-1220,
-1096,
2007,
-350,
-1756,
1613,
594,
-2042,
875,
1411,
-1892,
-51,
1927,
-1338,
-965,
2031,
-498,
-1674,
1702,
448,
-2025,
1008,
1298,
-1944,
100,
1871,
-1448,
-830,
2044,
-643,
-1583,
1781,
300,
-1998,
1137,
1178,
-1986,
250,
1805,
-1551,
-690,
2046,
-784,
-1483,
1850,
150,
-1959,
1259,
1052,
-2017,
399,
1729,
-1645,
-546,
2037,
-921,
-1375,
1909,
-1,
-1910,
1374,
920,
-2038,
545,
1644,
-1730,
-400,
2016,
-1053,
-1260,
1958,
-151,
-1851,
1482,
783,
-2047,
689,
1550,
-1806,
-251,
1985,
-1179,
-1138,
1997,
-301,
-1782,
1582,
642,
-2045,
829,
1447,
-1872,
-101,
1943,
-1299,
-1009,
2024,
-449,
-1703,
1673,
497,
-2032,
964,
1337,
-1928,
50,
1891,
-1412,
-876,
2041,
-595,
-1614,
1755,
349,
-2008,
1095,
1219,
-1973,
200,
1828,
-1517,
-737,
2047,
-737,
-1517,
1828,
200,
-1973,
1219,
1095,
-2008,
349,
1755,
-1614,
-595,
2041,
-876,
-1412,
1891,
50,
-1928,
1337,
964,
-2032,
497,
1673,
-1703,
-449,
2024,
-1009,
-1299,
1943,
-101,
-1872,
1447,
829,
-2045,
642,
1582,
-1782,
-301,
1997,
-1138,
-1179,
1985,
-251,
-1806,
1550,
689,
-2047,
783,
1482,
-1851,
-151,
1958,
-1260,
-1053,
2016,
-400,
-1730,
1644,
545,
-2038,
920,
1374,
-1910,
0,
};

#endif