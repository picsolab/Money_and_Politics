# Money and Politics
The data sets released here has been used in our study on "The Geography of Money and Politics." 

In this study, we examined the social antecedents for contributing to campaigns, with a particular focus on the role of population density and social networking opportunities. Using ten years of US campaign contribution data from the Federal Election Commission (FEC) and a national survey of party leaders, we reported interesting findings regarding the interplay among density and mobility (operationalized by commuting flows). This analysis also reveals differences between political parties. Democrats are more dependent on social networking in dense population areas. This difference in the importance of social networking opportunities present in geographical space helps explain macro-level patterns in party fundraising.

Our study was based on a collection of data sets, including: 1) FEC contribution, 2) US census, 3) US presidential vote share, 4) earning, and 5) commuting. See details in [data/readme.md](data/readme.md).

These data were used to create the final analysis dataset [data/messdata.zip](data/messdata.zip) consisting of variables in the models described in our R&P paper.

The MATLAB code can be used to reproduce the results w.r.t. all models specified in the paper. See the program entry point [code/mess_county_main.m](code/mess_county_main.m).

## Code dependency
The code utilizes the Econometrics Toolbox. It can be downloaded at: http://www.spatial-econometrics.com/

## Publication
If you make use of these data sets and code, please cite: 

Lin, Y.-R., Kennedy, R., Lazer, D. (2017). The Geography of Money and Politics: Population Density, Social Networking and Political Contributions. Research & Politics, 4(4) (doi: 10.1177/2053168017742015)