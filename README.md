matlab-sources
==============

git repository for the Matlab source code

List of folders contained in this repository :
	- filter-generator (script generating files containing discrete values sampled from the filter)
	- localization (scripts and functions processing trusted positions of the drone)
	- signal-processing (scripts processing both simulated and real signal and DFT implementation)
	
Detailed explanations for each folder :
	- filter-generator :
		- basic use : open and launch generateFilter.m
		- what it does : it will generate 4 files containing the discrete values representing the filter curve
		
	- localization :
		- basic use : open and launch likelyhoodAlgotithm.m
		- what it does : it tries to correlate the TDOA values given as input (tdoa table) to find trusted positions of the drone
		- how it works : 
			- the localization.m script generates the theoretical TDOA values for each point of the room
			- the rechercheIntervalleMinErr.m function searches for an interval of points which matches a given TDOA with an error given as parameter
			- the correlationMinErreurV2.m function tries to correlate the 3 intervals found by the previous function to determine the trusted position of the drone
			- the likelyhoodAlgotithm.m script calls the 3 previous scripts and plots the results
		- what to do to test it :
			- change the dimension of the room in localization.m (specify its dimensions in meters in dim table)
			- change the coteCube value in localization.m to divide the room with the precision you want
			- change the TDOA values in the table tdoa in likelyhoodAlgotithm.m script
			- change the toleranceMin and toleranceMax values in correlationMinErrV2.m to take measure imprecision into account
			- activate intermediate/final displays in the various scritps (xxOn variables at 1)
	
	- signal-processing :
		basic use : open and launch fenetreGlissante.m (simulated signals) or testFenetreGlissanteEchantillonsReel.m (real samples)
		what it does : it filters the given input signal and determine coefficients associated with each of the searched frequencies (39.5kHz to 41kHz with a 500Hz interval)
		how it works :
			- it applies given filters to the input signal in order to determine whether it is constituted of a given frequency or not on a 2ms window
			- it slides this window of a given number of points across the signal to process the whole signal
		