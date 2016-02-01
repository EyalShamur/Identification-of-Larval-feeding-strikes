#ifndef INITIALIZE_H_
#define INITIALIZE_H_

#include "DenseTrack.h"
#include "getopt.h"
#include <conio.h>

using namespace cv;
#define _MAX_DRIVE   3
#define _MAX_DIR   256
#define _MAX_FNAME   256
#define _MAX_EXT   256

void InitTrackInfo(TrackInfo* trackInfo, int track_length, int init_gap)
{
	trackInfo->length = track_length;
	trackInfo->gap = init_gap;
}

DescMat* InitDescMat(int height, int width, int nBins)
{
	DescMat* descMat = (DescMat*)malloc(sizeof(DescMat));
	descMat->height = height;
	descMat->width = width;
	descMat->nBins = nBins;

	long size = height*width*nBins;
	
	descMat->desc = (float*)malloc(size*sizeof(float));
	if (descMat->desc==0){
		printf("Failed to allocate memory\ndescMat->desc=0\n");
		printf("size = %d\n  Press any key....\n",size);
		getch();
		exit(0);
	}else{
		memset(descMat->desc, 0, size*sizeof(float));
	}
	return descMat;
}

void ReleDescMat(DescMat* descMat)
{
	free(descMat->desc);
	free(descMat);
}

void InitDescInfo(DescInfo* descInfo, int nBins, bool isHof, int size, int nxy_cell, int nt_cell)
{
	descInfo->nBins = nBins;
	descInfo->isHof = isHof;
	descInfo->nxCells = nxy_cell;
	descInfo->nyCells = nxy_cell;
	descInfo->ntCells = nt_cell;
	descInfo->dim = nBins*nxy_cell*nxy_cell;
	descInfo->height = size;
	descInfo->width = size;
}

void InitSeqInfo(SeqInfo* seqInfo, char* video)
{
	VideoCapture capture;
	capture.open(video);

	if(!capture.isOpened())
		fprintf(stderr, "Could not initialize capturing..\n");

	// get the number of frames in the video
	int frame_num = 0;
	while(true) {
		Mat frame;
		capture >> frame;

		if(frame.empty())
			break;

		if(frame_num == 0) {
			seqInfo->width = frame.cols;
			seqInfo->height = frame.rows;
		}

		frame_num++;
    }
	seqInfo->length = frame_num;
}

void usage()
{
	fprintf(stderr, "Extract dense trajectories from a video\n\n");
	fprintf(stderr, "Usage: DenseTrack video_file [options]\n");
	fprintf(stderr, "Options:\n");
	fprintf(stderr, "  -h                        Display this message and exit\n");
	fprintf(stderr, "  -S [start frame]          The start frame to compute feature (default: S=0 frame)\n");
	fprintf(stderr, "  -E [end frame]            The end frame for feature computing (default: E=last frame)\n");
	fprintf(stderr, "  -L [trajectory length]    The length of the trajectory (default: L=15 frames)\n");
	fprintf(stderr, "  -W [sampling stride]      The stride for dense sampling feature points (default: W=5 pixels)\n");
	fprintf(stderr, "  -N [neighborhood size]    The neighborhood size for computing the descriptor (default: N=32 pixels)\n");
	fprintf(stderr, "  -s [spatial cells]        The number of cells in the nxy axis (default: nxy=2 cells)\n");
	fprintf(stderr, "  -t [temporal cells]       The number of cells in the nt axis (default: nt=3 cells)\n");
	fprintf(stderr, "  -A [scale number]         The number of maximal spatial scales (default: 8 scales)\n");
	fprintf(stderr, "  -I [initial gap]          The gap for re-sampling feature points (default: 1 frame)\n");
}

bool arg_parse(int argc, char** argv)
{
	

	int c;
    char drive[_MAX_DRIVE];
    char dir[_MAX_DIR];
    char fname[_MAX_FNAME];
    char ext[_MAX_EXT];
    //char executable[_MAX_EXT+_MAX_FNAME+_MAX_DIR+_MAX_DRIVE];

	bool flag = false;
	//char* executable = basename(argv[0]);
	_splitpath(argv[0],drive,dir,fname,ext);
	string str_f_name = (string(drive)+string(dir)+string(fname)+string(ext));
    const char * executable = str_f_name.c_str();
		
	while((c = getopt (argc, argv, "hS:E:L:W:N:s:t:A:I:")) != -1)
	switch(c) {
		case 'S':
		start_frame = atoi(optarg);
		flag = true;
		break;
		case 'E':
		end_frame = atoi(optarg);
		flag = true;
		break;
		case 'L':
		track_length = atoi(optarg);
		break;
		case 'W':
		min_distance = atoi(optarg);
		break;
		case 'N':
		patch_size = atoi(optarg);
		break;
		case 's':
		nxy_cell = atoi(optarg);
		break;
		case 't':
		nt_cell = atoi(optarg);
		break;
		case 'A':
		scale_num = atoi(optarg);
		break;
		case 'I':
		init_gap = atoi(optarg);
		break;	

		case 'h':
		usage();
		exit(0);
		break;

		default:
		fprintf(stderr, "error parsing arguments at -%c\n  Try '%s -h' for help.", c, executable );
		abort();
	}
	return flag;
}

#endif /*INITIALIZE_H_*/
