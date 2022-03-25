%%
%% readme - PcodeReleaseUtility
% Introduction:
%  	This tool will be helpful to release development code for production use.
% 
% Helps to release the developed code into a Pcode. It supports multiple release scenarios.
%      * Package all the m-files into a single m-file.
%      * Convert every m-file as a p-file and follow the development folder structure.
%      * Convert every m-file as a p-file and move all the p-files into a single folder.
%      * Create help m-file with only the comments along with p-files.
% 
% How to use:
% 	1. Add PcodeReleaseUtility and PcodeReleaseUtility\utils folders into MATLAB path.
% 	2. Run ">> pcodeGUI" in the MATLAB command window to run the tool
%
% Developed by: Sysenso Systems, www.sysenso.com 
% Contact: contactus@sysenso.com
%
% Version:
% 1.0 - Initial Version.
% 1.1 - Added global checkbox to add/remove help files, Added API(releaseUtility.m) support for the tool.
%
%% Sample Usage:
% Please note the files from the testcases/sample1 folder are selected to
% package that a pcode file.
%
% <<Capture1.png>>
% 
% Different output formats.
%
% <<Capture2.png>>
% 
% 
%% API Support: releaseUtility
% releaseUtility(packagingMethod,folderOption,allFiles,helpChoice,mainFunctionPath,outputPath)
% Helps to release the files in a required format. This will reduce
% the time and effort during the release process.
%
% Syntax :
%  >> releaseUtility(packagingMethod,folderOption,allFiles,helpChoice,mainFunctionPath,outputPath)
%
% packagingMethod:
%       'single' - For a pcode file.
%       'multiple' - For a multiple pcode files.
%
% folderOption: This is applicable only for multiple packagingMethod.
%       'flat' - Files will be populated directly to the outputPath
%       'retain' - Files will be populated by retaining the relative folder structure.
%
% allFiles: List of files in the development folder will be given in a cell array.
%
% helpChoice: File-wise help choice (Logical array of n*1)
%       true - Help required, false - Help not required.
%
% mainFunctionPath - This is applicable only for single packagingMethod.
% Toplevel function path.
%
% outputPath: Release folder path
%
