#!/usr/bin/env python-sirius

import numpy as np
import matplotlib.pyplot as plt


# https://wiki-sirius.lnls.br/mediawiki/index.php/Machine:Magnets#SI_Quadrupole_Magnet_Sorting
SORTING_QUADS = [
    'SI-01M2:MA-QDA', 'Q14-081',
    'SI-05M1:MA-QDA', 'Q14-077',
    'SI-05M2:MA-QDA', 'Q14-028',
    'SI-09M1:MA-QDA', 'Q14-059',
    'SI-09M2:MA-QDA', 'Q14-062',
    'SI-13M1:MA-QDA', 'Q14-058',
    'SI-13M2:MA-QDA', 'Q14-040',
    'SI-17M1:MA-QDA', 'Q14-034',
    'SI-17M2:MA-QDA', 'Q14-068',
    'SI-01M1:MA-QDA', 'Q14-018',
    'SI-02M1:MA-QDB1', 'Q14-010',
    'SI-02M2:MA-QDB1', 'Q14-017',
    'SI-04M1:MA-QDB1', 'Q14-011',
    'SI-04M2:MA-QDB1', 'Q14-008',
    'SI-06M1:MA-QDB1', 'Q14-023',
    'SI-06M2:MA-QDB1', 'Q14-035',
    'SI-08M1:MA-QDB1', 'Q14-048',
    'SI-08M2:MA-QDB1', 'Q14-075',
    'SI-10M1:MA-QDB1', 'Q14-021',
    'SI-10M2:MA-QDB1', 'Q14-055',
    'SI-12M1:MA-QDB1', 'Q14-014',
    'SI-12M2:MA-QDB1', 'Q14-033',
    'SI-14M1:MA-QDB1', 'Q14-026',
    'SI-14M2:MA-QDB1', 'Q14-067',
    'SI-16M1:MA-QDB1', 'Q14-057',
    'SI-16M2:MA-QDB1', 'Q14-027',
    'SI-18M1:MA-QDB1', 'Q14-079',
    'SI-18M2:MA-QDB1', 'Q14-009',
    'SI-20M1:MA-QDB1', 'Q14-025',
    'SI-20M2:MA-QDB1', 'Q14-053',
    'SI-02M1:MA-QDB2', 'Q14-039',
    'SI-02M2:MA-QDB2', 'Q14-050',
    'SI-04M1:MA-QDB2', 'Q14-038',
    'SI-04M2:MA-QDB2', 'Q14-020',
    'SI-06M1:MA-QDB2', 'Q14-045',
    'SI-06M2:MA-QDB2', 'Q14-047',
    'SI-08M1:MA-QDB2', 'Q14-064',
    'SI-08M2:MA-QDB2', 'Q14-046',
    'SI-10M1:MA-QDB2', 'Q14-032',
    'SI-10M2:MA-QDB2', 'Q14-030',
    'SI-12M1:MA-QDB2', 'Q14-065',
    'SI-12M2:MA-QDB2', 'Q14-056',
    'SI-14M1:MA-QDB2', 'Q14-049',
    'SI-14M2:MA-QDB2', 'Q14-054',
    'SI-16M1:MA-QDB2', 'Q14-063',
    'SI-16M2:MA-QDB2', 'Q14-004',
    'SI-18M1:MA-QDB2', 'Q14-015',
    'SI-18M2:MA-QDB2', 'Q14-066',
    'SI-20M1:MA-QDB2', 'Q14-060',
    'SI-20M2:MA-QDB2', 'Q14-052',
    'SI-03M1:MA-QDP1', 'Q14-069',
    'SI-03M2:MA-QDP1', 'Q14-072',
    'SI-07M1:MA-QDP1', 'Q14-019',
    'SI-07M2:MA-QDP1', 'Q14-031',
    'SI-11M1:MA-QDP1', 'Q14-041',
    'SI-11M2:MA-QDP1', 'Q14-070',
    'SI-15M1:MA-QDP1', 'Q14-051',
    'SI-15M2:MA-QDP1', 'Q14-042',
    'SI-19M1:MA-QDP1', 'Q14-029',
    'SI-19M2:MA-QDP1', 'Q14-061',
    'SI-03M1:MA-QDP2', 'Q14-012',
    'SI-03M2:MA-QDP2', 'Q14-005',
    'SI-07M1:MA-QDP2', 'Q14-078',
    'SI-07M2:MA-QDP2', 'Q14-071',
    'SI-11M1:MA-QDP2', 'Q14-007',
    'SI-11M2:MA-QDP2', 'Q14-006',
    'SI-15M1:MA-QDP2', 'Q14-073',
    'SI-15M2:MA-QDP2', 'Q14-016',
    'SI-19M1:MA-QDP2', 'Q14-037',
    'SI-19M2:MA-QDP2', 'Q14-002',
    'SI-01M2:MA-QFA', 'Q20-076',
    'SI-05M1:MA-QFA', 'Q20-079',
    'SI-05M2:MA-QFA', 'Q20-176',
    'SI-09M1:MA-QFA', 'Q20-074',
    'SI-09M2:MA-QFA', 'Q20-101',
    'SI-13M1:MA-QFA', 'Q20-162',
    'SI-13M2:MA-QFA', 'Q20-155',
    'SI-17M1:MA-QFA', 'Q20-095',
    'SI-17M2:MA-QFA', 'Q20-071',
    'SI-01M1:MA-QFA', 'Q20-049',
    'SI-01C1:MA-Q1', 'Q20-030',
    'SI-01C4:MA-Q1', 'Q20-132',
    'SI-02C1:MA-Q1', 'Q20-013',
    'SI-02C4:MA-Q1', 'Q20-014',
    'SI-03C1:MA-Q1', 'Q20-027',
    'SI-03C4:MA-Q1', 'Q20-008',
    'SI-04C1:MA-Q1', 'Q20-029',
    'SI-04C4:MA-Q1', 'Q20-023',
    'SI-05C1:MA-Q1', 'Q20-149',
    'SI-05C4:MA-Q1', 'Q20-028',
    'SI-06C1:MA-Q1', 'Q20-036',
    'SI-06C4:MA-Q1', 'Q20-033',
    'SI-07C1:MA-Q1', 'Q20-020',
    'SI-07C4:MA-Q1', 'Q20-015',
    'SI-08C1:MA-Q1', 'Q20-125',
    'SI-08C4:MA-Q1', 'Q20-153',
    'SI-09C1:MA-Q1', 'Q20-025',
    'SI-09C4:MA-Q1', 'Q20-067',
    'SI-10C1:MA-Q1', 'Q20-035',
    'SI-10C4:MA-Q1', 'Q20-141',
    'SI-11C1:MA-Q1', 'Q20-119',
    'SI-11C4:MA-Q1', 'Q20-012',
    'SI-12C1:MA-Q1', 'Q20-111',
    'SI-12C4:MA-Q1', 'Q20-006',
    'SI-13C1:MA-Q1', 'Q20-164',
    'SI-13C4:MA-Q1', 'Q20-024',
    'SI-14C1:MA-Q1', 'Q20-010',
    'SI-14C4:MA-Q1', 'Q20-032',
    'SI-15C1:MA-Q1', 'Q20-011',
    'SI-15C4:MA-Q1', 'Q20-005',
    'SI-16C1:MA-Q1', 'Q20-039',
    'SI-16C4:MA-Q1', 'Q20-109',
    'SI-17C1:MA-Q1', 'Q20-016',
    'SI-17C4:MA-Q1', 'Q20-009',
    'SI-18C1:MA-Q1', 'Q20-026',
    'SI-18C4:MA-Q1', 'Q20-037',
    'SI-19C1:MA-Q1', 'Q20-038',
    'SI-19C4:MA-Q1', 'Q20-017',
    'SI-20C1:MA-Q1', 'Q20-007',
    'SI-20C4:MA-Q1', 'Q20-021',
    'SI-01C1:MA-Q2', 'Q20-096',
    'SI-01C4:MA-Q2', 'Q20-034',
    'SI-02C1:MA-Q2', 'Q20-092',
    'SI-02C4:MA-Q2', 'Q20-122',
    'SI-03C1:MA-Q2', 'Q20-136',
    'SI-03C4:MA-Q2', 'Q20-174',
    'SI-04C1:MA-Q2', 'Q20-056',
    'SI-04C4:MA-Q2', 'Q20-059',
    'SI-05C1:MA-Q2', 'Q20-128',
    'SI-05C4:MA-Q2', 'Q20-115',
    'SI-06C1:MA-Q2', 'Q20-126',
    'SI-06C4:MA-Q2', 'Q20-158',
    'SI-07C1:MA-Q2', 'Q20-073',
    'SI-07C4:MA-Q2', 'Q20-087',
    'SI-08C1:MA-Q2', 'Q20-137',
    'SI-08C4:MA-Q2', 'Q20-082',
    'SI-09C1:MA-Q2', 'Q20-050',
    'SI-09C4:MA-Q2', 'Q20-117',
    'SI-10C1:MA-Q2', 'Q20-105',
    'SI-10C4:MA-Q2', 'Q20-124',
    'SI-11C1:MA-Q2', 'Q20-120',
    'SI-11C4:MA-Q2', 'Q20-118',
    'SI-12C1:MA-Q2', 'Q20-134',
    'SI-12C4:MA-Q2', 'Q20-135',
    'SI-13C1:MA-Q2', 'Q20-068',
    'SI-13C4:MA-Q2', 'Q20-098',
    'SI-14C1:MA-Q2', 'Q20-072',
    'SI-14C4:MA-Q2', 'Q20-175',
    'SI-15C1:MA-Q2', 'Q20-178',
    'SI-15C4:MA-Q2', 'Q20-104',
    'SI-16C1:MA-Q2', 'Q20-046',
    'SI-16C4:MA-Q2', 'Q20-154',
    'SI-17C1:MA-Q2', 'Q20-167',
    'SI-17C4:MA-Q2', 'Q20-094',
    'SI-18C1:MA-Q2', 'Q20-062',
    'SI-18C4:MA-Q2', 'Q20-102',
    'SI-19C1:MA-Q2', 'Q20-131',
    'SI-19C4:MA-Q2', 'Q20-138',
    'SI-20C1:MA-Q2', 'Q20-065',
    'SI-20C4:MA-Q2', 'Q20-152',
    'SI-01C2:MA-Q3', 'Q20-066',
    'SI-01C3:MA-Q3', 'Q20-061',
    'SI-02C2:MA-Q3', 'Q20-091',
    'SI-02C3:MA-Q3', 'Q20-004',
    'SI-03C2:MA-Q3', 'Q20-147',
    'SI-03C3:MA-Q3', 'Q20-114',
    'SI-04C2:MA-Q3', 'Q20-112',
    'SI-04C3:MA-Q3', 'Q20-165',
    'SI-05C2:MA-Q3', 'Q20-107',
    'SI-05C3:MA-Q3', 'Q20-019',
    'SI-06C2:MA-Q3', 'Q20-179',
    'SI-06C3:MA-Q3', 'Q20-106',
    'SI-07C2:MA-Q3', 'Q20-148',
    'SI-07C3:MA-Q3', 'Q20-108',
    'SI-08C2:MA-Q3', 'Q20-070',
    'SI-08C3:MA-Q3', 'Q20-159',
    'SI-09C2:MA-Q3', 'Q20-121',
    'SI-09C3:MA-Q3', 'Q20-045',
    'SI-10C2:MA-Q3', 'Q20-042',
    'SI-10C3:MA-Q3', 'Q20-130',
    'SI-11C2:MA-Q3', 'Q20-161',
    'SI-11C3:MA-Q3', 'Q20-075',
    'SI-12C2:MA-Q3', 'Q20-127',
    'SI-12C3:MA-Q3', 'Q20-022',
    'SI-13C2:MA-Q3', 'Q20-145',
    'SI-13C3:MA-Q3', 'Q20-133',
    'SI-14C2:MA-Q3', 'Q20-172',
    'SI-14C3:MA-Q3', 'Q20-129',
    'SI-15C2:MA-Q3', 'Q20-018',
    'SI-15C3:MA-Q3', 'Q20-142',
    'SI-16C2:MA-Q3', 'Q20-139',
    'SI-16C3:MA-Q3', 'Q20-113',
    'SI-17C2:MA-Q3', 'Q20-140',
    'SI-17C3:MA-Q3', 'Q20-170',
    'SI-18C2:MA-Q3', 'Q20-110',
    'SI-18C3:MA-Q3', 'Q20-044',
    'SI-19C2:MA-Q3', 'Q20-086',
    'SI-19C3:MA-Q3', 'Q20-177',
    'SI-20C2:MA-Q3', 'Q20-031',
    'SI-20C3:MA-Q3', 'Q20-064',
    'SI-01C2:MA-Q4', 'Q20-081',
    'SI-01C3:MA-Q4', 'Q20-097',
    'SI-02C2:MA-Q4', 'Q20-051',
    'SI-02C3:MA-Q4', 'Q20-168',
    'SI-03C2:MA-Q4', 'Q20-166',
    'SI-03C3:MA-Q4', 'Q20-043',
    'SI-04C2:MA-Q4', 'Q20-080',
    'SI-04C3:MA-Q4', 'Q20-047',
    'SI-05C2:MA-Q4', 'Q20-163',
    'SI-05C3:MA-Q4', 'Q20-048',
    'SI-06C2:MA-Q4', 'Q20-103',
    'SI-06C3:MA-Q4', 'Q20-116',
    'SI-07C2:MA-Q4', 'Q20-089',
    'SI-07C3:MA-Q4', 'Q20-077',
    'SI-08C2:MA-Q4', 'Q20-093',
    'SI-08C3:MA-Q4', 'Q20-063',
    'SI-09C2:MA-Q4', 'Q20-100',
    'SI-09C3:MA-Q4', 'Q20-054',
    'SI-10C2:MA-Q4', 'Q20-156',
    'SI-10C3:MA-Q4', 'Q20-169',
    'SI-11C2:MA-Q4', 'Q20-057',
    'SI-11C3:MA-Q4', 'Q20-058',
    'SI-12C2:MA-Q4', 'Q20-090',
    'SI-12C3:MA-Q4', 'Q20-150',
    'SI-13C2:MA-Q4', 'Q20-144',
    'SI-13C3:MA-Q4', 'Q20-085',
    'SI-14C2:MA-Q4', 'Q20-052',
    'SI-14C3:MA-Q4', 'Q20-069',
    'SI-15C2:MA-Q4', 'Q20-123',
    'SI-15C3:MA-Q4', 'Q20-084',
    'SI-16C2:MA-Q4', 'Q20-143',
    'SI-16C3:MA-Q4', 'Q20-171',
    'SI-17C2:MA-Q4', 'Q20-053',
    'SI-17C3:MA-Q4', 'Q20-157',
    'SI-18C2:MA-Q4', 'Q20-078',
    'SI-18C3:MA-Q4', 'Q20-146',
    'SI-19C2:MA-Q4', 'Q20-060',
    'SI-19C3:MA-Q4', 'Q20-160',
    'SI-20C2:MA-Q4', 'Q20-173',
    'SI-20C3:MA-Q4', 'Q20-083',
    'SI-02M1:MA-QFB', 'Q30-016',
    'SI-02M2:MA-QFB', 'Q30-032',
    'SI-04M1:MA-QFB', 'Q30-010',
    'SI-04M2:MA-QFB', 'Q30-019',
    'SI-06M1:MA-QFB', 'Q30-008',
    'SI-06M2:MA-QFB', 'Q30-036',
    'SI-08M1:MA-QFB', 'Q30-011',
    'SI-08M2:MA-QFB', 'Q30-035',
    'SI-10M1:MA-QFB', 'Q30-009',
    'SI-10M2:MA-QFB', 'Q30-020',
    'SI-12M1:MA-QFB', 'Q30-029',
    'SI-12M2:MA-QFB', 'Q30-014',
    'SI-14M1:MA-QFB', 'Q30-013',
    'SI-14M2:MA-QFB', 'Q30-024',
    'SI-16M1:MA-QFB', 'Q30-005',
    'SI-16M2:MA-QFB', 'Q30-021',
    'SI-18M1:MA-QFB', 'Q30-025',
    'SI-18M2:MA-QFB', 'Q30-030',
    'SI-20M1:MA-QFB', 'Q30-023',
    'SI-20M2:MA-QFB', 'Q30-022',
    'SI-03M1:MA-QFP', 'Q30-033',
    'SI-03M2:MA-QFP', 'Q30-027',
    'SI-07M1:MA-QFP', 'Q30-017',
    'SI-07M2:MA-QFP', 'Q30-006',
    'SI-11M1:MA-QFP', 'Q30-026',
    'SI-11M2:MA-QFP', 'Q30-034',
    'SI-15M1:MA-QFP', 'Q30-015',
    'SI-15M2:MA-QFP', 'Q30-031',
    'SI-19M1:MA-QFP', 'Q30-007',
    'SI-19M2:MA-QFP', 'Q30-004',
]

# https://wiki-sirius.lnls.br/mediawiki/index.php/Machine:Magnets#SI_Sextupole_Magnet_Sorting
SORTING_SEXTS = [
    'SI-01M2:MA-SDA0', 'S15-004',
    'SI-05M1:MA-SDA0', 'S15-007',
    'SI-05M2:MA-SDA0', 'S15-270',
    'SI-09M1:MA-SDA0', 'S15-240',
    'SI-09M2:MA-SDA0', 'S15-283',
    'SI-13M1:MA-SDA0', 'S15-122',
    'SI-13M2:MA-SDA0', 'S15-184',
    'SI-17M1:MA-SDA0', 'S15-273',
    'SI-17M2:MA-SDA0', 'S15-118',
    'SI-01M1:MA-SDA0', 'S15-261',
    'SI-01M2:MA-SFA0', 'S15-278',
    'SI-05M1:MA-SFA0', 'S15-246',
    'SI-05M2:MA-SFA0', 'S15-276',
    'SI-09M1:MA-SFA0', 'S15-009',
    'SI-09M2:MA-SFA0', 'S15-015',
    'SI-13M1:MA-SFA0', 'S15-279',
    'SI-13M2:MA-SFA0', 'S15-033',
    'SI-17M1:MA-SFA0', 'S15-016',
    'SI-17M2:MA-SFA0', 'S15-010',
    'SI-01M1:MA-SFA0', 'S15-172',
    'SI-02M1:MA-SDB0', 'S15-159',
    'SI-02M2:MA-SDB0', 'S15-119',
    'SI-04M1:MA-SDB0', 'S15-132',
    'SI-04M2:MA-SDB0', 'S15-101',
    'SI-06M1:MA-SDB0', 'S15-026',
    'SI-06M2:MA-SDB0', 'S15-085',
    'SI-08M1:MA-SDB0', 'S15-259',
    'SI-08M2:MA-SDB0', 'S15-264',
    'SI-10M1:MA-SDB0', 'S15-154',
    'SI-10M2:MA-SDB0', 'S15-131',
    'SI-12M1:MA-SDB0', 'S15-241',
    'SI-12M2:MA-SDB0', 'S15-108',
    'SI-14M1:MA-SDB0', 'S15-086',
    'SI-14M2:MA-SDB0', 'S15-114',
    'SI-16M1:MA-SDB0', 'S15-213',
    'SI-16M2:MA-SDB0', 'S15-106',
    'SI-18M1:MA-SDB0', 'S15-157',
    'SI-18M2:MA-SDB0', 'S15-023',
    'SI-20M1:MA-SDB0', 'S15-045',
    'SI-20M2:MA-SDB0', 'S15-239',
    'SI-02M1:MA-SFB0', 'S15-076',
    'SI-02M2:MA-SFB0', 'S15-133',
    'SI-04M1:MA-SFB0', 'S15-152',
    'SI-04M2:MA-SFB0', 'S15-082',
    'SI-06M1:MA-SFB0', 'S15-074',
    'SI-06M2:MA-SFB0', 'S15-163',
    'SI-08M1:MA-SFB0', 'S15-103',
    'SI-08M2:MA-SFB0', 'S15-075',
    'SI-10M1:MA-SFB0', 'S15-072',
    'SI-10M2:MA-SFB0', 'S15-208',
    'SI-12M1:MA-SFB0', 'S15-039',
    'SI-12M2:MA-SFB0', 'S15-048',
    'SI-14M1:MA-SFB0', 'S15-070',
    'SI-14M2:MA-SFB0', 'S15-053',
    'SI-16M1:MA-SFB0', 'S15-038',
    'SI-16M2:MA-SFB0', 'S15-151',
    'SI-18M1:MA-SFB0', 'S15-077',
    'SI-18M2:MA-SFB0', 'S15-013',
    'SI-20M1:MA-SFB0', 'S15-056',
    'SI-20M2:MA-SFB0', 'S15-073',
    'SI-03M1:MA-SDP0', 'S15-041',
    'SI-03M2:MA-SDP0', 'S15-110',
    'SI-07M1:MA-SDP0', 'S15-113',
    'SI-07M2:MA-SDP0', 'S15-269',
    'SI-11M1:MA-SDP0', 'S15-230',
    'SI-11M2:MA-SDP0', 'S15-147',
    'SI-15M1:MA-SDP0', 'S15-143',
    'SI-15M2:MA-SDP0', 'S15-193',
    'SI-19M1:MA-SDP0', 'S15-232',
    'SI-19M2:MA-SDP0', 'S15-187',
    'SI-03M1:MA-SFP0', 'S15-249',
    'SI-03M2:MA-SFP0', 'S15-221',
    'SI-07M1:MA-SFP0', 'S15-238',
    'SI-07M2:MA-SFP0', 'S15-044',
    'SI-11M1:MA-SFP0', 'S15-274',
    'SI-11M2:MA-SFP0', 'S15-135',
    'SI-15M1:MA-SFP0', 'S15-043',
    'SI-15M2:MA-SFP0', 'S15-040',
    'SI-19M1:MA-SFP0', 'S15-258',
    'SI-19M2:MA-SFP0', 'S15-093',
    'SI-01C1:MA-SDA1', 'S15-138',
    'SI-04C4:MA-SDA1', 'S15-120',
    'SI-05C1:MA-SDA1', 'S15-195',
    'SI-08C4:MA-SDA1', 'S15-212',
    'SI-09C1:MA-SDA1', 'S15-207',
    'SI-12C4:MA-SDA1', 'S15-164',
    'SI-13C1:MA-SDA1', 'S15-100',
    'SI-16C4:MA-SDA1', 'S15-141',
    'SI-17C1:MA-SDA1', 'S15-223',
    'SI-20C4:MA-SDA1', 'S15-112',
    'SI-01C1:MA-SFA1', 'S15-142',
    'SI-04C4:MA-SFA1', 'S15-219',
    'SI-05C1:MA-SFA1', 'S15-102',
    'SI-08C4:MA-SFA1', 'S15-286',
    'SI-09C1:MA-SFA1', 'S15-236',
    'SI-12C4:MA-SFA1', 'S15-266',
    'SI-13C1:MA-SFA1', 'S15-265',
    'SI-16C4:MA-SFA1', 'S15-272',
    'SI-17C1:MA-SFA1', 'S15-098',
    'SI-20C4:MA-SFA1', 'S15-105',
    'SI-01C4:MA-SDB1', 'S15-168',
    'SI-02C1:MA-SDB1', 'S15-181',
    'SI-03C4:MA-SDB1', 'S15-174',
    'SI-04C1:MA-SDB1', 'S15-128',
    'SI-05C4:MA-SDB1', 'S15-146',
    'SI-06C1:MA-SDB1', 'S15-268',
    'SI-07C4:MA-SDB1', 'S15-139',
    'SI-08C1:MA-SDB1', 'S15-202',
    'SI-09C4:MA-SDB1', 'S15-244',
    'SI-10C1:MA-SDB1', 'S15-242',
    'SI-11C4:MA-SDB1', 'S15-149',
    'SI-12C1:MA-SDB1', 'S15-124',
    'SI-13C4:MA-SDB1', 'S15-107',
    'SI-14C1:MA-SDB1', 'S15-189',
    'SI-15C4:MA-SDB1', 'S15-188',
    'SI-16C1:MA-SDB1', 'S15-177',
    'SI-17C4:MA-SDB1', 'S15-186',
    'SI-18C1:MA-SDB1', 'S15-126',
    'SI-19C4:MA-SDB1', 'S15-123',
    'SI-20C1:MA-SDB1', 'S15-170',
    'SI-01C4:MA-SFB1', 'S15-104',
    'SI-02C1:MA-SFB1', 'S15-080',
    'SI-03C4:MA-SFB1', 'S15-061',
    'SI-04C1:MA-SFB1', 'S15-067',
    'SI-05C4:MA-SFB1', 'S15-068',
    'SI-06C1:MA-SFB1', 'S15-034',
    'SI-07C4:MA-SFB1', 'S15-060',
    'SI-08C1:MA-SFB1', 'S15-081',
    'SI-09C4:MA-SFB1', 'S15-156',
    'SI-10C1:MA-SFB1', 'S15-257',
    'SI-11C4:MA-SFB1', 'S15-234',
    'SI-12C1:MA-SFB1', 'S15-182',
    'SI-13C4:MA-SFB1', 'S15-233',
    'SI-14C1:MA-SFB1', 'S15-169',
    'SI-15C4:MA-SFB1', 'S15-059',
    'SI-16C1:MA-SFB1', 'S15-275',
    'SI-17C4:MA-SFB1', 'S15-153',
    'SI-18C1:MA-SFB1', 'S15-052',
    'SI-19C4:MA-SFB1', 'S15-071',
    'SI-20C1:MA-SFB1', 'S15-065',
    'SI-02C4:MA-SDP1', 'S15-092',
    'SI-03C1:MA-SDP1', 'S15-017',
    'SI-06C4:MA-SDP1', 'S15-175',
    'SI-07C1:MA-SDP1', 'S15-271',
    'SI-10C4:MA-SDP1', 'S15-020',
    'SI-11C1:MA-SDP1', 'S15-050',
    'SI-14C4:MA-SDP1', 'S15-109',
    'SI-15C1:MA-SDP1', 'S15-012',
    'SI-18C4:MA-SDP1', 'S15-155',
    'SI-19C1:MA-SDP1', 'S15-227',
    'SI-02C4:MA-SFP1', 'S15-063',
    'SI-03C1:MA-SFP1', 'S15-260',
    'SI-06C4:MA-SFP1', 'S15-180',
    'SI-07C1:MA-SFP1', 'S15-176',
    'SI-10C4:MA-SFP1', 'S15-250',
    'SI-11C1:MA-SFP1', 'S15-209',
    'SI-14C4:MA-SFP1', 'S15-165',
    'SI-15C1:MA-SFP1', 'S15-253',
    'SI-18C4:MA-SFP1', 'S15-229',
    'SI-19C1:MA-SFP1', 'S15-251',
    'SI-01C1:MA-SDA2', 'S15-248',
    'SI-04C4:MA-SDA2', 'S15-277',
    'SI-05C1:MA-SDA2', 'S15-245',
    'SI-08C4:MA-SDA2', 'S15-029',
    'SI-09C1:MA-SDA2', 'S15-256',
    'SI-12C4:MA-SDA2', 'S15-167',
    'SI-13C1:MA-SDA2', 'S15-031',
    'SI-16C4:MA-SDA2', 'S15-263',
    'SI-17C1:MA-SDA2', 'S15-166',
    'SI-20C4:MA-SDA2', 'S15-032',
    'SI-01C2:MA-SFA2', 'S15-282',
    'SI-04C3:MA-SFA2', 'S15-117',
    'SI-05C2:MA-SFA2', 'S15-021',
    'SI-08C3:MA-SFA2', 'S15-145',
    'SI-09C2:MA-SFA2', 'S15-220',
    'SI-12C3:MA-SFA2', 'S15-243',
    'SI-13C2:MA-SFA2', 'S15-171',
    'SI-16C3:MA-SFA2', 'S15-280',
    'SI-17C2:MA-SFA2', 'S15-281',
    'SI-20C3:MA-SFA2', 'S15-005',
    'SI-01C4:MA-SDB2', 'S15-197',
    'SI-02C1:MA-SDB2', 'S15-247',
    'SI-03C4:MA-SDB2', 'S15-218',
    'SI-04C1:MA-SDB2', 'S15-099',
    'SI-05C4:MA-SDB2', 'S15-211',
    'SI-06C1:MA-SDB2', 'S15-006',
    'SI-07C4:MA-SDB2', 'S15-235',
    'SI-08C1:MA-SDB2', 'S15-130',
    'SI-09C4:MA-SDB2', 'S15-226',
    'SI-10C1:MA-SDB2', 'S15-254',
    'SI-11C4:MA-SDB2', 'S15-162',
    'SI-12C1:MA-SDB2', 'S15-206',
    'SI-13C4:MA-SDB2', 'S15-096',
    'SI-14C1:MA-SDB2', 'S15-224',
    'SI-15C4:MA-SDB2', 'S15-140',
    'SI-16C1:MA-SDB2', 'S15-225',
    'SI-17C4:MA-SDB2', 'S15-129',
    'SI-18C1:MA-SDB2', 'S15-027',
    'SI-19C4:MA-SDB2', 'S15-222',
    'SI-20C1:MA-SDB2', 'S15-203',
    'SI-01C3:MA-SFB2', 'S15-121',
    'SI-02C2:MA-SFB2', 'S15-190',
    'SI-03C3:MA-SFB2', 'S15-192',
    'SI-04C2:MA-SFB2', 'S15-087',
    'SI-05C3:MA-SFB2', 'S15-210',
    'SI-06C2:MA-SFB2', 'S15-231',
    'SI-07C3:MA-SFB2', 'S15-158',
    'SI-08C2:MA-SFB2', 'S15-115',
    'SI-09C3:MA-SFB2', 'S15-008',
    'SI-10C2:MA-SFB2', 'S15-160',
    'SI-11C3:MA-SFB2', 'S15-019',
    'SI-12C2:MA-SFB2', 'S15-267',
    'SI-13C3:MA-SFB2', 'S15-078',
    'SI-14C2:MA-SFB2', 'S15-030',
    'SI-15C3:MA-SFB2', 'S15-090',
    'SI-16C2:MA-SFB2', 'S15-116',
    'SI-17C3:MA-SFB2', 'S15-018',
    'SI-18C2:MA-SFB2', 'S15-097',
    'SI-19C3:MA-SFB2', 'S15-179',
    'SI-20C2:MA-SFB2', 'S15-185',
    'SI-02C4:MA-SDP2', 'S15-252',
    'SI-03C1:MA-SDP2', 'S15-199',
    'SI-06C4:MA-SDP2', 'S15-088',
    'SI-07C1:MA-SDP2', 'S15-024',
    'SI-10C4:MA-SDP2', 'S15-079',
    'SI-11C1:MA-SDP2', 'S15-191',
    'SI-14C4:MA-SDP2', 'S15-025',
    'SI-15C1:MA-SDP2', 'S15-014',
    'SI-18C4:MA-SDP2', 'S15-161',
    'SI-19C1:MA-SDP2', 'S15-028',
    'SI-02C3:MA-SFP2', 'S15-062',
    'SI-03C2:MA-SFP2', 'S15-049',
    'SI-06C3:MA-SFP2', 'S15-194',
    'SI-07C2:MA-SFP2', 'S15-064',
    'SI-10C3:MA-SFP2', 'S15-237',
    'SI-11C2:MA-SFP2', 'S15-127',
    'SI-14C3:MA-SFP2', 'S15-057',
    'SI-15C2:MA-SFP2', 'S15-173',
    'SI-18C3:MA-SFP2', 'S15-089',
    'SI-19C2:MA-SFP2', 'S15-054',
    'SI-01C2:MA-SDA3', 'S15-217',
    'SI-04C3:MA-SDA3', 'S15-215',
    'SI-05C2:MA-SDA3', 'S15-035',
    'SI-08C3:MA-SDA3', 'S15-144',
    'SI-09C2:MA-SDA3', 'S15-216',
    'SI-12C3:MA-SDA3', 'S15-214',
    'SI-13C2:MA-SDA3', 'S15-204',
    'SI-16C3:MA-SDA3', 'S15-036',
    'SI-17C2:MA-SDA3', 'S15-051',
    'SI-20C3:MA-SDA3', 'S15-022',
    'SI-01C3:MA-SDB3', 'S15-084',
    'SI-02C2:MA-SDB3', 'S15-111',
    'SI-03C3:MA-SDB3', 'S15-228',
    'SI-04C2:MA-SDB3', 'S15-150',
    'SI-05C3:MA-SDB3', 'S15-198',
    'SI-06C2:MA-SDB3', 'S15-201',
    'SI-07C3:MA-SDB3', 'S15-196',
    'SI-08C2:MA-SDB3', 'S15-125',
    'SI-09C3:MA-SDB3', 'S15-183',
    'SI-10C2:MA-SDB3', 'S15-205',
    'SI-11C3:MA-SDB3', 'S15-047',
    'SI-12C2:MA-SDB3', 'S15-200',
    'SI-13C3:MA-SDB3', 'S15-037',
    'SI-14C2:MA-SDB3', 'S15-148',
    'SI-15C3:MA-SDB3', 'S15-058',
    'SI-16C2:MA-SDB3', 'S15-178',
    'SI-17C3:MA-SDB3', 'S15-255',
    'SI-18C2:MA-SDB3', 'S15-134',
    'SI-19C3:MA-SDB3', 'S15-083',
    'SI-20C2:MA-SDB3', 'S15-046',
    'SI-02C3:MA-SDP3', 'S15-042',
    'SI-03C2:MA-SDP3', 'S15-095',
    'SI-06C3:MA-SDP3', 'S15-055',
    'SI-07C2:MA-SDP3', 'S15-094',
    'SI-10C3:MA-SDP3', 'S15-011',
    'SI-11C2:MA-SDP3', 'S15-262',
    'SI-14C3:MA-SDP3', 'S15-136',
    'SI-15C2:MA-SDP3', 'S15-284',
    'SI-18C3:MA-SDP3', 'S15-137',
    'SI-19C2:MA-SDP3', 'S15-285',
]


q14_fnames = [
    './quadrupoles-q14/MULTIPOLES-2A.txt',
    './quadrupoles-q14/MULTIPOLES-4A.txt',
    './quadrupoles-q14/MULTIPOLES-6A.txt',
    './quadrupoles-q14/MULTIPOLES-8A.txt',
    './quadrupoles-q14/MULTIPOLES-10A.txt',
    './quadrupoles-q14/MULTIPOLES-30A.txt',
    './quadrupoles-q14/MULTIPOLES-50A.txt',
    './quadrupoles-q14/MULTIPOLES-70A.txt',
    './quadrupoles-q14/MULTIPOLES-90A.txt',
    './quadrupoles-q14/MULTIPOLES-110A.txt',
    './quadrupoles-q14/MULTIPOLES-130A.txt',
    './quadrupoles-q14/MULTIPOLES-148A.txt',
    ]


q20_fnames = [
    './quadrupoles-q20/MULTIPOLES-2A.txt',
    './quadrupoles-q20/MULTIPOLES-4A.txt',
    './quadrupoles-q20/MULTIPOLES-6A.txt',
    './quadrupoles-q20/MULTIPOLES-8A.txt',
    './quadrupoles-q20/MULTIPOLES-10A.txt',
    './quadrupoles-q20/MULTIPOLES-30A.txt',
    './quadrupoles-q20/MULTIPOLES-50A.txt',
    './quadrupoles-q20/MULTIPOLES-70A.txt',
    './quadrupoles-q20/MULTIPOLES-90A.txt',
    './quadrupoles-q20/MULTIPOLES-110A.txt',
    './quadrupoles-q20/MULTIPOLES-130A.txt',
    './quadrupoles-q20/MULTIPOLES-157A.txt',
    ]


q30_fnames = [
    './quadrupoles-q30/MULTIPOLES-2A.txt',
    './quadrupoles-q30/MULTIPOLES-4A.txt',
    './quadrupoles-q30/MULTIPOLES-6A.txt',
    './quadrupoles-q30/MULTIPOLES-8A.txt',
    './quadrupoles-q30/MULTIPOLES-10A.txt',
    './quadrupoles-q30/MULTIPOLES-30A.txt',
    './quadrupoles-q30/MULTIPOLES-50A.txt',
    './quadrupoles-q30/MULTIPOLES-70A.txt',
    './quadrupoles-q30/MULTIPOLES-90A.txt',
    './quadrupoles-q30/MULTIPOLES-110A.txt',
    './quadrupoles-q30/MULTIPOLES-130A.txt',
    './quadrupoles-q30/MULTIPOLES-155A.txt',
    ]


s15_fnames = [
    './sextupoles-s15/MULTIPOLES-2A.txt',
    './sextupoles-s15/MULTIPOLES-4A.txt',
    './sextupoles-s15/MULTIPOLES-6A.txt',
    './sextupoles-s15/MULTIPOLES-8A.txt',
    './sextupoles-s15/MULTIPOLES-10A.txt',
    './sextupoles-s15/MULTIPOLES-30A.txt',
    './sextupoles-s15/MULTIPOLES-50A.txt',
    './sextupoles-s15/MULTIPOLES-70A.txt',
    './sextupoles-s15/MULTIPOLES-90A.txt',
    './sextupoles-s15/MULTIPOLES-110A.txt',
    './sextupoles-s15/MULTIPOLES-130A.txt',
    './sextupoles-s15/MULTIPOLES-150A.txt',
    './sextupoles-s15/MULTIPOLES-168A.txt',
]

def get_sorting(sextupoles=False):

    SORTING = SORTING_SEXTS if sextupoles else SORTING_QUADS
    magnets = SORTING[::2]
    serials = SORTING[1::2]
    fams = dict()
    for magnet, serial in zip(magnets, serials):
        fam = magnet.split('-')[2]
        if fam not in fams:
            fams[fam] = [serial]
        else:
            fams[fam].append(serial)
    return fams


def multipole_plot(magnets, currents, harmonics, multipoles_normal, multipoles_skew, harm, typ):
    idx = harmonics.index(harm)
    if typ == 'normal':
        data = multipoles_normal[:, idx]
        title = 'Normal'
    else:
        data = multipoles_skew[:, idx]
        title = 'Skew'
    title += ' multipole values for harmonic n = {}'.format(harm)

    data = data * currents
    fig, ax = plt.subplots()
    x = np.arange(len(magnets))
    ax.bar(x, data)
    ax.set_title(title)
    ax.set_xlabel('Integrated multipole [T/m^(n-1)]'.format(harm))
    ax.set_ylabel('Integrated multipole [T/m^(n-1)]'.format(harm))
    ax.set_xticks(x)
    ax.set_xticklabels(magnets, rotation=90)
    plt.show()


def multipole_read_file(fname):

    with open(fname, 'r') as fp:
        lines = fp.readlines()

    magnets = list()
    harmonics = list()
    currents = list()
    multipoles_normal = list()
    multipoles_skew = list()
    for line in lines:
        line = line.strip()
        if line.startswith('#'):
            if '# harmonics' in line:
                _, harmonics = line.split('):')
                harmonics = [int(word) for word in harmonics.split()]
                # print(harmonics)
            continue
        magnet, current, *mpoles = line.split()
        mpoles = [float(mpole) for mpole in mpoles]
        # first column: magnet name
        magnets.append(magnet)
        # second column: measurement current
        currents.append(float(current))
        # next group: normal multipoles for all harmonics, normalized by excitation current
        multipoles_normal.append(mpoles[:len(harmonics)])
        # next group: skew multipoles for all harmonics, normalized by excitation current
        multipoles_skew.append(mpoles[len(harmonics):])

    currents = np.array(currents)
    multipoles_normal = np.array(multipoles_normal)
    multipoles_skew = np.array(multipoles_skew)

    return magnets, currents, harmonics, multipoles_normal, multipoles_skew


def multipole_get_avg(fname, magnets_fam, exclude_harms, invert_polarity=False):
    magnets, currents, harmonics, multipoles_normal, multipoles_skew = multipole_read_file(fname)
    indices = [magnets.index(mag) for mag in magnets_fam]
    selection = \
        list(set(np.arange(len(harmonics))) - set([harmonics.index(h) for h in exclude_harms]))
    # print(selection)

    factor = -1.0 if invert_polarity else 1.0

    nmpoles = multipoles_normal[:, selection]
    smpoles = multipoles_skew[:, selection]
    nmpoles = factor * nmpoles[indices, :]
    smpoles = factor * smpoles[indices, :]
    currents = currents[indices]
    for i in range(len(currents)):
        nmpoles[i, :] *= currents[i]
        smpoles[i, :] *= currents[i]

    current = np.mean(currents)
    nmpoles_avg = np.mean(nmpoles, 0)
    smpoles_avg = np.mean(smpoles, 0)
    nmpoles_std = np.std(nmpoles, 0)
    smpoles_std = np.std(smpoles, 0)

    return current, harmonics, nmpoles_avg, smpoles_avg, nmpoles_std, smpoles_std


def excdata_print(fam, fnames, exclude_harms, label, main_harmonic, sextupoles=False, extrapolation_current=None, rescaling=0.2908, invert_polarity=False):

    fams = get_sorting(sextupoles)
    magnets_fam = fams[fam]

    rescaling = 1 + rescaling/100

    # get data from file and build
    excdata_avg = list()
    excdata_std = list()
    for fname in fnames:
        current, harmonics, nmpoles_avg, smpoles_avg, nmpoles_std, smpoles_std = \
            multipole_get_avg(fname, magnets_fam, exclude_harms, invert_polarity)
        datum = np.array([0.0, ] * (1 + len(nmpoles_avg) + len(smpoles_avg)))
        datum[0] = current
        datum[1::2] = nmpoles_avg
        datum[2::2] = smpoles_avg
        excdata_avg.append(datum.copy())
        datum[1::2] = nmpoles_std
        datum[2::2] = smpoles_std
        excdata_std.append(datum.copy())

    # linear extrapolation at I = 0
    datum1 = excdata_avg[0]
    datum2 = excdata_avg[1]
    x1, x2 = datum1[0], datum2[0]
    y1, y2 = np.array(datum1[1:]), np.array(datum2[1:])
    b = (x2 * y1 - x1 * y2) / (x2 - x1)
    excdata_avg.insert(0, [0,] + list(b))
    excdata_avg = np.array(excdata_avg)

    datum1 = excdata_std[0]
    datum2 = excdata_std[1]
    x1, x2 = datum1[0], datum2[0]
    y1, y2 = np.array(datum1[1:]), np.array(datum2[1:])
    b = (x2 * y1 - x1 * y2) / (x2 - x1)
    excdata_std.insert(0, [0,] + list(b))
    excdata_std = np.array(excdata_avg)

    if extrapolation_current is not None:
        currents = excdata_avg[:, 0]
        datum_avg = np.zeros(excdata_avg.shape[1])
        datum_avg[0] = extrapolation_current
        datum_std = np.zeros(excdata_std.shape[1])
        datum_std[0] = extrapolation_current
        for i in range(1, excdata_avg.shape[1]):
            mpoles_data = excdata_avg[:, i]
            poly = np.polyfit(currents[-3:], mpoles_data[-3:], 2)
            mpoles_fit = np.polyval(poly, extrapolation_current)
            datum_avg[i] = mpoles_fit
            mpoles_data = excdata_std[:, i]
            poly = np.polyfit(currents[-3:], mpoles_data[-3:], 2)
            mpoles_fit = np.polyval(poly, extrapolation_current)
            datum_std[i] = mpoles_fit
        excdata_avg = np.vstack((excdata_avg, datum_avg))
        excdata_std = np.vstack((excdata_std, datum_std))

    print('# HEADER')
    print('# ======')
    print('# label             {}'.format(label))
    print('# harmonics         ', end='')
    for h in harmonics:
        if h not in exclude_harms:
            print('{} '.format(h), end='')
    print()
    print('# main_harmonic     {}'.format(main_harmonic))
    print('# rescaling_factor  {:.6f}'.format(rescaling))
    print('# units             Ampere  ', end='')
    for h in harmonics:
        if h not in exclude_harms:
            if h == 0:
                fmt = 'T*m'
            elif h == 1:
                fmt = 'T'
            elif h == 2:
                fmt = 'T/m'
            else:
                fmt = 'T/m^{}'.format(h-1)
            print('{} {}  '.format(fmt, fmt), end='')
    print()
    print()
    print('# EXCITATION DATA')
    print('# ===============')

    for line in excdata_avg:
        print('{:+09.4f} '.format(line[0]), end='')
        for i in range(len(line[1:])//2):
            if harmonics[i] not in exclude_harms:
                print('{:+.4e} {:+.4e}  '.format(line[1+2*i+0], line[1+2*i+1]), end='')
        print()
    print()

    print('# COMMENTS')
    print('# ========')
    print('# 1. generated automatically with "excdata.py"')
    print('# 2. data taken from rotcoil measurements')
    print('# 3. data for zero current is extrapolated from data points with lowest measured currents')
    print('# 4. average excitation curves for magnets:', end='')
    for i in range(len(magnets_fam)):
        if i % 10 == 0:
            print('\n#    ', end='')
        print('{} '.format(magnets_fam[i]), end='')
    print()
    if extrapolation_current is not None:
        print('# 5. last data point was extrapolated from a quadratic fitting using last 3 points.')
    if sextupoles:
        print('# 6. rescaling factor based on new measurements compared to previous ones')
        print('#    === S15 ===')
        print('#    Family          Current[A] GL2020[T/m] GL2019[T/m] Diff[%]')
        print('#    SI-Fam:PS-SFA0   034.98     -79.16832   -78.79904  +0.469')
        print('#    SI-Fam:PS-SFB0   049.05    -111.06953  -110.60355  +0.421')
        print('#    SI-Fam:PS-SFP0   049.05    -111.06953  -110.60355  +0.421')
        print('#    SI-Fam:PS-SFA2   100.28    -226.93267  -226.12582  +0.357')
        print('#    SI-Fam:PS-SFA1   128.48    -288.11642  -287.21829  +0.313')
        print('#    SI-Fam:PS-SFB2   132.81    -297.45731  -296.61973  +0.282')
        print('#    SI-Fam:PS-SFP2   133.33    -298.58556  -297.76223  +0.277')
        print('#    SI-Fam:PS-SFB1   155.22    -344.48435  -351.10163  -1.885')
        print('#    SI-Fam:PS-SFP1   156.53    -346.61199  -354.72640  -2.288')
        print('#    SI-Fam:PS-SDB0   043.18     +97.72405   +97.30107  +0.435')
        print('#    SI-Fam:PS-SDP0   043.18     +97.72405   +97.30107  +0.435')
        print('#    SI-Fam:PS-SDA0   053.72    +121.71106  +121.21016  +0.413')
        print('#    SI-Fam:PS-SDA2   059.29    +134.38117  +133.83979  +0.404')
        print('#    SI-Fam:PS-SDB2   081.57    +184.93776  +184.24588  +0.376')
        print('#    SI-Fam:PS-SDP2   081.55    +184.89068  +184.19894  +0.376')
        print('#    SI-Fam:PS-SDA3   093.40    +211.57649  +210.80689  +0.365')
        print('#    SI-Fam:PS-SDB1   094.58    +214.22775  +213.45115  +0.364')
        print('#    SI-Fam:PS-SDP1   095.00    +215.17967  +214.40061  +0.363')
        print('#    SI-Fam:PS-SDA1   109.04    +246.21948  +245.37664  +0.343')
        print('#    SI-Fam:PS-SDB3   116.56    +262.52284  +261.65091  +0.333')
        print('#    SI-Fam:PS-SDP3   116.79    +263.03286  +262.15994  +0.333')

    print()
    print('# POLARITY TABLE')
    print('# ==============')
    print('#')
    print('# Magnet function         | IntStrength(1) | IntField(2) | ConvSign(3) | Current(4)')
    print('# ------------------------|----------------|-------------|-------------|-----------')
    print('# dipole                  | Angle > 0      | BYL  < 0    | -1.0        | I > 0')
    print('# corrector-horizontal    | HKick > 0      | BYL  > 0    | +1.0        | I > 0')
    print('# corrector-vertical      | VKick > 0      | BXL  < 0    | -1.0        | I > 0')
    print('# quadrupole (focusing)   | KL    > 0      | D1NL < 0    | -1.0        | I > 0')
    print('# quadrupole (defocusing) | KL    < 0      | D1NL > 0    | -1.0        | I > 0')
    print('# quadrupole (skew)       | KL    < 0      | D1SL > 0    | -1.0        | I > 0')
    print('# sextupole  (focusing)   | SL    > 0      | D2NL < 0    | -1.0        | I > 0')
    print('# sextupole  (defocusing) | SL    < 0      | D2NL > 0    | -1.0        | I > 0')
    print('#')
    print('# Defs:')
    print('# ----')
    print('# BYL   := \int{dz By|_{x=y=0}}.')
    print('# BXL   := \int{dz Bx|_{x=y=0}}.')
    print('# D1NL  := \int{dz \\frac{dBy}{dx}_{x=y=0}}')
    print('# D2NL  := (1/2!) \int{dz \\frac{d^2By}{dx^2}_{x=y=0}}')
    print('# D1SL  := \int{dz \\frac{dBx}{dx}_{x=y=0}}')
    print('# Brho  := magnetic rigidity.')
    print('# Angle := ConvSign * BYL / abs(Brho)')
    print('# HKick := ConvSign * BYL / abs(Brho)')
    print('# VKick := ConvSign * BXL / abs(Brho)')
    print('# KL    := ConvSign * D1NL / abs(Brho)')
    print('# KL    := ConvSign * D1SL / abs(Brho)')
    print('# SL    := ConvSign * D2NL / abs(Brho)')
    print('#')
    print('# Obs:')
    print('# ---')
    print('# (1) Parameter definition.')
    print('#     IntStrength values correspond to integrated PolynomA and PolynomB parameters')
    print('#     of usual beam tracking codes, with the exception that VKick has its sign')
    print('#     reversed with respecto to its corresponding value in PolynomA.')
    print('# (2) Sirius coordinate system and Lorentz force.')
    print('# (3) Conversion sign for IntField <-> IntStrength')
    print('# (4) Convention of magnet excitation polarity, so that when I > 0 the strength')
    print('#     of the magnet has the expected conventional sign.')
    print('')
    print('# STATIC DATA FILE FORMAT')
    print('# =======================')
    print('#')
    print('# These static data files should comply with the following formatting rules:')
    print('# 1. If the first alphanumeric character of the line is not the pound sign')
    print('#    then the lines is a comment.')
    print('# 2. If the first alphanumeric character is "#" then if')
    print('#    a) it is followed by "[<parameter>] <value>" a parameter names <parameter>')
    print('#       is define with value <value>. if the string <value> has spaces in it')
    print('#       it is split as a list of strings.')
    print('#    b) otherwise the line is ignored as a comment line.')

    return harmonics, excdata_avg, excdata_std


def excdata_read(magnet):

    if 'Q14' in magnet:
        fnames = q14_fnames
    elif 'Q20' in magnet:
        fnames = q20_fnames
    elif 'Q30' in magnet:
        fnames = q30_fnames
    else:
        fnames = s15_fnames

    currents = list()
    mpoles_normal = list()
    mpoles_skew = list()
    for fname in fnames:
        magnets, currs, harmonics, multipoles_normal, multipoles_skew = \
            multipole_read_file(fname)
        idx_magnet = magnets.index(magnet)
        curr = currs[idx_magnet]
        mpoles_normal.append(curr * np.array(multipoles_normal[idx_magnet, :]))
        mpoles_skew.append(curr * np.array(multipoles_skew[idx_magnet, :]))
        currents.append(curr)
    currents = np.array(currents)
    mpoles_normal = np.array(mpoles_normal)
    mpoles_skew = np.array(mpoles_skew)
    return harmonics, currents, mpoles_normal, mpoles_skew


def excdata_read_family(fam, sextupoles=False):
    families = get_sorting(sextupoles)
    magnets = families[fam]
    currents = list()
    mpoles_normal = list()
    mpoles_skew = list()
    for magnet in magnets:
        harmonics, currs, mpoles_n, mpoles_s = excdata_read(magnet)
        currents.append(currs)
        mpoles_normal.append(mpoles_n)
        mpoles_skew.append(mpoles_s)
    currents = np.array(currents)
    mpoles_normal = np.array(mpoles_normal)
    mpoles_skew = np.array(mpoles_skew)
    return magnets, harmonics, currents, mpoles_normal, mpoles_skew


def excdata_plot_families(magnet_type):

    fams = {
        'Q14': ['QDA', 'QDB1', 'QDB2', 'QDP1', 'QDP2'],
        'Q20': ['QFA', 'Q1', 'Q2', 'Q3', 'Q4'],
        'Q30': ['QFB', 'QFP'],
        'S15': ['SFA0', 'SFA1', 'SFA2', 'SFB0', 'SFB1', 'SFB2', 'SFP0', 'SFP1', 'SFP2', ]
    }

    if magnet_type.startswith('Q'):
        harm = 1
        grad_name = 'GL/I'
        magfunc = 'Quadrupole'
        sextupoles = False
    else:
        harm = 2
        grad_name = 'SL/I'
        magfunc = 'Sextupole'
        sextupoles = True

    fams = fams[magnet_type]

    allquads = None
    for fam in fams:
        magnets, harmonics, currents, mpoles_normal, mpoles_skew = excdata_read_family(fam, sextupoles)
        idx = harmonics.index(harm)
        quadrupoles = mpoles_normal[:, :, idx] / currents
        if allquads is None:
            allquads = quadrupoles
        else:
            allquads = np.vstack((allquads, quadrupoles))
    allquads_avg = np.mean(allquads, 0)

    for fam in fams:
        magnets, harmonics, currents, mpoles_normal, mpoles_skew = excdata_read_family(fam, sextupoles)
        idx = harmonics.index(harm)
        quadrupoles = mpoles_normal[:, :, idx] / currents
        for i in range(mpoles_normal.shape[0]):
            x = currents[i, :]
            y = 100*(mpoles_normal[i, :, idx] / currents[i, :] - allquads_avg) / allquads_avg
            plt.plot(x, y)

    plt.plot([0, np.max(currents)], [-0.05, -0.05], '--k', label='spec +/- 0.05%')
    plt.plot([0, np.max(currents)], [+0.05, +0.05], '--k')
    plt.xlabel('Current [A]')
    plt.ylabel(grad_name + ' - spread [%]')
    plt.title('Spread for ' + magnet_type + ' -  Integrated ' + magfunc + ' Normalized By Current')
    plt.legend()
    plt.grid()
    plt.show()


def excdata_plot_family(fam, sextupoles=False):

    magnets, harmonics, currents, mpoles_normal, mpoles_skew = \
        excdata_read_family(fam, sextupoles)
    if sextupoles:
        harm = 2
        grad_name = 'SL/I'
        magfunc = 'Sextupole'
    else:
        harm = 1
        grad_name = 'GL/I'
        magfunc = 'Quadrupole'
    idx = harmonics.index(harm)
    print(magnets)
    print('harmonics: ', len(harmonics))
    print('mpoles   : ', mpoles_normal.shape)
    print('currents : ', currents.shape)

    # currents_avg = np.mean(currents, 0)
    # for i in range(len(magnets)):
    #     data = 100 * (currents[i, :] - currents_avg) / currents_avg
    #     plt.plot(currents_avg, data, '-o', label=magnets[i])
    # plt.legend()
    # plt.xlabel('Current [A]')
    # plt.ylabel('Current spread [%]')
    # plt.title('Current spread for ' + fam + ' measurements')
    # plt.grid()
    # plt.show()

    # for i in range(len(magnets)):
    #     data = mpoles_normal[i, :, idx]
    #     plt.plot(currents[i, :], data, '-o', label=magnets[i])
    # plt.legend()
    # plt.xlabel('Current [A]')
    # plt.ylabel('GL [T]')
    # plt.title(fam + ' Integrated Quadrupole')
    # plt.grid()
    # plt.show()

    # for i in range(len(magnets)):
    #     data = mpoles_normal[i, :, idx] / currents[i, :]
    #     plt.plot(currents[i, :], data, '-o', label=magnets[i])
    # plt.legend()
    # plt.xlabel('Current [A]')
    # plt.ylabel('GL/I [T/A]')
    # plt.title(fam + ' Integrated Quadrupole Normalized By Current')
    # plt.grid()
    # plt.show()

    mpoles_avg = np.mean(mpoles_normal[:, :, idx] / currents, 0)
    for i in range(len(magnets)):
        data = 100 * (mpoles_normal[i, :, idx] / currents[i, :] - mpoles_avg) / mpoles_avg
        plt.plot(currents[i, :], data, '-o', label=magnets[i])
    plt.plot([min(currents[0,:]), max(currents[0,:])], [+0.05, +0.05], 'k--', label='spec +/- 0.05%')
    plt.plot([min(currents[0,:]), max(currents[0,:])], [-0.05, -0.05], 'k--')
    plt.legend()
    plt.xlabel('Current [A]')
    plt.ylabel(grad_name + ' spread [%]')
    plt.title('Spread for ' + fam + ' Integrated ' + magfunc + ' Normalized By Current')
    plt.grid()
    plt.show()


def excdata_QDA():

    fam = 'QDA'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = q14_fnames
    label = 'si-quadrupole-q14-qda-fam'
    main_harmonic = '1 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(1)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('GL [T]')
    plt.grid()
    plt.title('QDA Family Excitation Curve')
    plt.show()


def excdata_QDB1():

    fam = 'QDB1'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = q14_fnames
    label = 'si-quadrupole-q14-qdb1-fam'
    main_harmonic = '1 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(1)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('GL [T]')
    plt.grid()
    plt.title('QDB1 Family Excitation Curve')
    plt.show()


def excdata_QDB2():

    fam = 'QDB2'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = q14_fnames
    label = 'si-quadrupole-q14-qdb2-fam'
    main_harmonic = '1 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(1)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('GL [T]')
    plt.grid()
    plt.title('QDB2 Family Excitation Curve')
    plt.show()


def excdata_QDP1():

    fam = 'QDP1'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = q14_fnames
    label = 'si-quadrupole-q14-qdp1-fam'
    main_harmonic = '1 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(1)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('GL [T]')
    plt.grid()
    plt.title('QDP1 Family Excitation Curve')
    plt.show()


def excdata_QDP2():

    fam = 'QDP2'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = q14_fnames
    label = 'si-quadrupole-q14-qdp2-fam'
    main_harmonic = '1 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(1)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('GL [T]')
    plt.grid()
    plt.title('QDP2 Family Excitation Curve')
    plt.show()


def excdata_QFA():

    fam = 'QFA'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = q20_fnames
    label = 'si-quadrupole-q20-qfa-fam'
    main_harmonic = '1 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(1)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('GL [T]')
    plt.grid()
    plt.title('QFA Family Excitation Curve')
    plt.show()


def excdata_Q1():

    fam = 'Q1'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = q20_fnames
    label = 'si-quadrupole-q20-q1-fam'
    main_harmonic = '1 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(1)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('GL [T]')
    plt.grid()
    plt.title('Q1 Family Excitation Curve')
    plt.show()


def excdata_Q2():

    fam = 'Q2'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = q20_fnames
    label = 'si-quadrupole-q20-q2-fam'
    main_harmonic = '1 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(1)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('GL [T]')
    plt.grid()
    plt.title('Q2 Family Excitation Curve')
    plt.show()


def excdata_Q3():

    fam = 'Q3'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = q20_fnames
    label = 'si-quadrupole-q20-q3-fam'
    main_harmonic = '1 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(1)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('GL [T]')
    plt.grid()
    plt.title('Q3 Family Excitation Curve')
    plt.show()


def excdata_Q4():

    fam = 'Q4'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = q20_fnames
    label = 'si-quadrupole-q20-q4-fam'
    main_harmonic = '1 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(1)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('GL [T]')
    plt.grid()
    plt.title('Q4 Family Excitation Curve')
    plt.show()


def excdata_QFB():

    fam = 'QFB'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = q30_fnames
    label = 'si-quadrupole-q30-qfb-fam'
    main_harmonic = '1 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(1)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('GL [T]')
    plt.grid()
    plt.title('QFB Family Excitation Curve')
    plt.show()


def excdata_QFP():

    fam = 'QFP'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = q30_fnames
    label = 'si-quadrupole-q30-qfp-fam'
    main_harmonic = '1 normal'

    harmonics, excdata_avg, excdata_std = \
    excdata_print(fam, fnames, exclude_harms, label, main_harmonic)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(1)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('GL [T]')
    plt.grid()
    plt.title('QFP Family Excitation Curve')
    plt.show()


def excdata_SFA0():

    fam = 'SFA0'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = s15_fnames
    label = 'si-sextupole-s15-sfa0-fam'
    main_harmonic = '2 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic, sextupoles=True, extrapolation_current=180)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(2)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('SL [T/m]')
    plt.grid()
    plt.title('SFA0 Family Excitation Curve')
    plt.show()


def excdata_SFA1():

    fam = 'SFA1'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = s15_fnames
    label = 'si-sextupole-s15-sfa1-fam'
    main_harmonic = '2 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic, sextupoles=True, extrapolation_current=180)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(2)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('SL [T/m]')
    plt.grid()
    plt.title('SFA1 Family Excitation Curve')
    plt.show()


def excdata_SFA2():

    fam = 'SFA2'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = s15_fnames
    label = 'si-sextupole-s15-sfa2-fam'
    main_harmonic = '2 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic, sextupoles=True, extrapolation_current=180)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(2)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('SL [T/m]')
    plt.grid()
    plt.title('SFA2 Family Excitation Curve')
    plt.show()


def excdata_SFB0():

    fam = 'SFB0'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = s15_fnames
    label = 'si-sextupole-s15-sfb0-fam'
    main_harmonic = '2 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic, sextupoles=True, extrapolation_current=180)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(2)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('SL [T/m]')
    plt.grid()
    plt.title('SFB0 Family Excitation Curve')
    plt.show()


def excdata_SFB1():

    fam = 'SFB1'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = s15_fnames
    label = 'si-sextupole-s15-sfb1-fam'
    main_harmonic = '2 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic, sextupoles=True, extrapolation_current=180)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(2)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('SL [T/m]')
    plt.grid()
    plt.title('SFB1 Family Excitation Curve')
    plt.show()


def excdata_SFB2():

    fam = 'SFB2'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = s15_fnames
    label = 'si-sextupole-s15-sfb2-fam'
    main_harmonic = '2 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic, sextupoles=True, extrapolation_current=180)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(2)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('SL [T/m]')
    plt.grid()
    plt.title('SFB2 Family Excitation Curve')
    plt.show()


def excdata_SFP0():

    fam = 'SFP0'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = s15_fnames
    label = 'si-sextupole-s15-sfp0-fam'
    main_harmonic = '2 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic, sextupoles=True, extrapolation_current=180)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(2)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('SL [T/m]')
    plt.grid()
    plt.title('SFP0 Family Excitation Curve')
    plt.show()


def excdata_SFP1():

    fam = 'SFP1'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = s15_fnames
    label = 'si-sextupole-s15-sfp1-fam'
    main_harmonic = '2 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic, sextupoles=True, extrapolation_current=180)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(2)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('SL [T/m]')
    plt.grid()
    plt.title('SFP1 Family Excitation Curve')
    plt.show()


def excdata_SFP2():

    fam = 'SFP2'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = s15_fnames
    label = 'si-sextupole-s15-sfp2-fam'
    main_harmonic = '2 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic, sextupoles=True, extrapolation_current=180)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(2)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('SL [T/m]')
    plt.grid()
    plt.title('SFP2 Family Excitation Curve')
    plt.show()


def excdata_SDA0():

    fam = 'SDA0'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = s15_fnames
    label = 'si-sextupole-s15-sda0-fam'
    main_harmonic = '2 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic,
            sextupoles=True, extrapolation_current=180, rescaling=0.413, invert_polarity=True)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(2)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('SL [T/m]')
    plt.grid()
    plt.title(fam + ' Family Excitation Curve')
    plt.show()


def excdata_SDA1():

    fam = 'SDA1'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = s15_fnames
    label = 'si-sextupole-s15-sda1-fam'
    main_harmonic = '2 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic,
            sextupoles=True, extrapolation_current=180, rescaling=0.343, invert_polarity=True)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(2)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('SL [T/m]')
    plt.grid()
    plt.title(fam + ' Family Excitation Curve')
    plt.show()


def excdata_SDA2():

    fam = 'SDA2'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = s15_fnames
    label = 'si-sextupole-s15-sda2-fam'
    main_harmonic = '2 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic, sextupoles=True,
                      extrapolation_current=180, rescaling=0.404, invert_polarity=True)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(2)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('SL [T/m]')
    plt.grid()
    plt.title(fam + ' Family Excitation Curve')
    plt.show()


def excdata_SDA3():

    fam = 'SDA3'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = s15_fnames
    label = 'si-sextupole-s15-sda3-fam'
    main_harmonic = '2 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic, sextupoles=True,
                      extrapolation_current=180, rescaling=0.365, invert_polarity=True)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(2)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('SL [T/m]')
    plt.grid()
    plt.title(fam + ' Family Excitation Curve')
    plt.show()


def excdata_SDB0():

    fam = 'SDB0'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = s15_fnames
    label = 'si-sextupole-s15-sdb0-fam'
    main_harmonic = '2 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic, sextupoles=True,
                      extrapolation_current=180, rescaling=0.435, invert_polarity=True)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(2)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('SL [T/m]')
    plt.grid()
    plt.title(fam + ' Family Excitation Curve')
    plt.show()


def excdata_SDB1():

    fam = 'SDB1'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = s15_fnames
    label = 'si-sextupole-s15-sdb1-fam'
    main_harmonic = '2 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic, sextupoles=True,
                      extrapolation_current=180, rescaling=0.365, invert_polarity=True)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(2)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('SL [T/m]')
    plt.grid()
    plt.title(fam + ' Family Excitation Curve')
    plt.show()


def excdata_SDB2():

    fam = 'SDB2'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = s15_fnames
    label = 'si-sextupole-s15-sdb2-fam'
    main_harmonic = '2 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic, sextupoles=True,
                      extrapolation_current=180, rescaling=0.376, invert_polarity=True)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(2)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('SL [T/m]')
    plt.grid()
    plt.title(fam + ' Family Excitation Curve')
    plt.show()


def excdata_SDB3():

    fam = 'SDB3'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = s15_fnames
    label = 'si-sextupole-s15-sdb3-fam'
    main_harmonic = '2 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic, sextupoles=True,
                      extrapolation_current=180, rescaling=0.333, invert_polarity=True)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(2)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('SL [T/m]')
    plt.grid()
    plt.title(fam + ' Family Excitation Curve')
    plt.show()


def excdata_SDP0():

    fam = 'SDP0'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = s15_fnames
    label = 'si-sextupole-s15-sdp0-fam'
    main_harmonic = '2 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic, sextupoles=True,
                      extrapolation_current=180, rescaling=0.435, invert_polarity=True)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(2)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('SL [T/m]')
    plt.grid()
    plt.title(fam + ' Family Excitation Curve')
    plt.show()


def excdata_SDP1():

    fam = 'SDP1'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = s15_fnames
    label = 'si-sextupole-s15-sdp1-fam'
    main_harmonic = '2 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic, sextupoles=True,
                      extrapolation_current=180, rescaling=0.363, invert_polarity=True)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(2)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('SL [T/m]')
    plt.grid()
    plt.title(fam + ' Family Excitation Curve')
    plt.show()


def excdata_SDP2():

    fam = 'SDP2'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = s15_fnames
    label = 'si-sextupole-s15-sdp2-fam'
    main_harmonic = '2 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic, sextupoles=True,
                      extrapolation_current=180, rescaling=0.376, invert_polarity=True)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(2)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('SL [T/m]')
    plt.grid()
    plt.title(fam + ' Family Excitation Curve')
    plt.show()


def excdata_SDP3():

    fam = 'SDP3'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = s15_fnames
    label = 'si-sextupole-s15-sdp3-fam'
    main_harmonic = '2 normal'

    harmonics, excdata_avg, excdata_std = \
        excdata_print(fam, fnames, exclude_harms, label, main_harmonic, sextupoles=True,
                      extrapolation_current=180, rescaling=0.333, invert_polarity=True)

    excdata_avg = np.array(excdata_avg)

    currents = excdata_avg[:, 0]
    idx = harmonics.index(2)
    plt.plot(currents, excdata_avg[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('SL [T/m]')
    plt.grid()
    plt.title(fam + ' Family Excitation Curve')
    plt.show()



# Q14 quadrupoles
# excdata_QDA()
# excdata_QDB1()
# excdata_QDB2()
# excdata_QDP1()
# excdata_QDP2()

# Q20 quadrupoles
# excdata_QFA()
# excdata_Q1()
# excdata_Q2()
# excdata_Q3()
# excdata_Q4()

# Q30 quadrupoles
# excdata_QFB()
# excdata_QFP()

# excdata_SFA0()
# excdata_SFA1()
# excdata_SFA2()

# excdata_SFB0()
# excdata_SFB1()
# excdata_SFB2()

# excdata_SFP0()
# excdata_SFP1()
# excdata_SFP2()

# excdata_SDA0()
# excdata_SDA1()
# excdata_SDA2()
# excdata_SDA3()
# excdata_SDB0()
# excdata_SDB1()
# excdata_SDB2()
# excdata_SDB3()
# excdata_SDP0()
# excdata_SDP1()
# excdata_SDP2()
excdata_SDP3()

# excdata_plot_family('QDA')
# excdata_plot_family('QDB1')
# excdata_plot_family('QDB2')
# excdata_plot_family('QDP1')
# excdata_plot_family('QDP2')
# excdata_plot_family('QFA')
# excdata_plot_family('Q1')
# excdata_plot_family('Q2')
# excdata_plot_family('Q3')
# excdata_plot_family('Q4')
# excdata_plot_family('QFB')
# excdata_plot_family('QFP')

# excdata_plot_family('SFA0', True)

# excdata_plot_families('Q14')
# excdata_plot_families('Q20')
# excdata_plot_families('Q30')

# excdata_plot_families('S15')
