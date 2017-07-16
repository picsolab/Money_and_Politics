Money and Politics Datasets
===========================

These datasets contain political contribution (FEC) aggregated by geographical regions and the attributes of those regions. The data can be used to study the relationship between political activity and geographical distribution. They were used to create the final analysis data "messdata.zip" consisting of variables in the models described in our R&P paper.

There are five types of data: 1) contribution, 2) census, 3) vote share, 4) earning, and 5) commuting. See details below.

The naming of the data files is based on following parameters:
* geo-unit: There are three levels of geographical units or regions: state, county, and zip code area. I created this dataset for all three levels whenever they are possible; however, fine-grained data in certain aspects (e.g., commuting) is not available. In our R&P paper, we used the "county" level data.
* yStart, yEnd: The start and end years of the data.


1) FEC -- political contribution: regrdata_geopoli/aggyear_<geo-unit>_<yStart>_<yEnd>_*.csv

The individual contributions are aggregated by geo-units (state, county, and zcode) and by election cycles (2000, 2002, 2004, 2006, 2008, and 2010). 
For examples:
aggyear_state_y2000_y2010_seatall_allstates__I.csv -- contains contributions aggregated by state, from year 2000 to year 2010, for all states.
aggyear_county_y2000_y2000_seatall_statesAK__I.csv -- contains contributions aggregated by county, for election year 2000, within state Alaska.
aggyear_zcode_y2000_y2000_seatall_statesAK_R_I.csv -- contains contributions aggregated by zip code area, for election year 2000, within state Alaska, to Republican candidates.

In these files, each line has three columns: 
zoneID, money, freq
which indicate the identifier of each geo-unit, the total amount of contribution in dollars, and the number of individual contributions.

Original data: The bulk FEC data can be downloaded from [influenceexplorer](http://data.influenceexplorer.com/bulk/).

2) Census -- income and population density: regrdata_geopoli/census_<geo-unit>.csv 

There are three files: census_state.csv, census_county.csv and census_zcode.csv

In these files, each line has 14 columns: 
zcode, cntyfips, cntyname, state, statename, area, lat, lon, zpop, zinc, cpop, cinc, spop, sinc
which indicate zip code (NA for higher unit), county fips code, county name (empty for higher unit), state abbreviation, area in square miles, latitude, longitude, population in the zip code area (empty for higher unit), income of the zip code area (empty for higher unit), population in the county (empty for higher unit), income of the county (empty for higher unit), population in the state, income of the state

Original data: The census data can be downloaded from [Missouri Census Data Center (MCDC)](http://mcdc.missouri.edu/cgi-bin/uexplore?/pub/data/sf32000)
- the data for county+state is generated from Dexter, by selecting 2 datasets:
select dataset: [sf32000](http://mcdc.missouri.edu/cgi-bin/uexplore?/pub/data/sf32000)
	- [/pub/data/sf32000/usstcntygeos](http://mcdc2.missouri.edu/cgi-bin/broker?_PROGRAM=websas.uex2dex.sas&_SERVICE=appdev&path=/pub/data/sf32000&dset=usstcntygeos&view=0)             
	- [/pub/data/sf32000/usstcnty](http://mcdc2.missouri.edu/cgi-bin/broker?_PROGRAM=websas.uex2dex.sas&_SERVICE=appdev&path=/pub/data/sf32000&dset=usstcnty&view=0)        	
- the data for zcode is generated from Dexter, by selecting 2 datasets:
select dataset: [sf32000](http://mcdc.missouri.edu/cgi-bin/uexplore?/pub/data/sf32000)
	- [/pub/data/sf32000/uszipsgeos](http://mcdc2.missouri.edu/cgi-bin/broker?_PROGRAM=websas.uex2dex.sas&_SERVICE=appdev&path=/pub/data/sf32000&dset=uszipsgeos&view=0) - Contains just the geographic ID fields as read from the Census Bureau usgeo3_uf3 file. We kept only the complete 3-digit and 5-digit ZCTA levels on this dataset.
	- [/pub/data/sf32000/uszipsph](http://mcdc2.missouri.edu/cgi-bin/broker?_PROGRAM=websas.uex2dex.sas&_SERVICE=appdev&path=/pub/data/sf32000&dset=uszipsph&view=0) - U.S. ZCTA (ZIP) and 3-digit ZCTA level summaries: P and H tables       

3) US presidential vote share: regrdata_geopoli/voteshare_<geo-unit>_<yStart>_<yEnd>.csv

In these files, each line contains three columns:
zoneID, repVoteshare, totalVotes
which indicate the identifier of each geo-unit, the Republican vote share, total number of votes.

Original data: downloaded at [cqpress](http://library.cqpress.com.ezp-prod1.hul.harvard.edu/elections/export.php)

4) Earning: regrdata_geopoli/earning_<geo-unit>.csv

In these files, each line contains 23 columns:
zoneID,totalPop,earningPop,earningPop1,earningPop2,earningPop3,earningPop4,earningPop5,earningPop6,earningPop7,earningPop8,earningPop9,earningPop10,earningPop11,earningPop12,earningPop13,earningPop14,earningPop15,earningPop16,earningPop17,earningPop18,earningPop19,earningPop20
which indicate the identifier of each geo-unit, the total population of the geo-unit, the earning population, and 20 breaks of the earning population. The last break is the population earning 100K or more.

Original data: the data for earnings and household income are described in [socialexplorer](http://www.socialexplorer.com/)    
- [P84.](http://www.socialexplorer.com/pub/reportdata/metabrowser.aspx?survey=C2000&ds=Summary+File+3&table=P084&header=True) Sex By Earnings In 1999 Dollars For The Population 16+ Years With Earnings
	- Universe: Population 16 years and over with earnings    
- [P52.](http://www.socialexplorer.com/pub/reportdata/metabrowser.aspx?survey=C2000&ds=Summary+File+3&table=P052&header=True)	Household Income In 1999 Dollars
	- Universe: Households

5) Commuting flow: US_census_commuting_network
See readme.txt under the folder for file format description.
The file US_Census_County_Commuting_Network.csv contains county-to-county commuting population. The incoming and outgoing flow can be generated from this file. 


------------------------------------------------
Yu-Ru Lin, May 2013
