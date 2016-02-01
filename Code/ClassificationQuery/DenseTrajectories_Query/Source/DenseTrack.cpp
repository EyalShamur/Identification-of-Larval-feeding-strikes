#include "DenseTrack.h"
#include "Initialize.h"
#include "Descriptors.h"
#include "OpticalFlow.h"

#include <time.h>
#include <string>
#include <getopt.h>


using namespace cv;

int show_track = 0; // set show_track = 1, if you want to visualize the trajectories
int do_dense_track(char* video,int flag,FILE* info_file,FILE* traj_file,FILE* hog_file,FILE* hof_file,FILE* mbhx_file,FILE* mbhy_file);

int main(int argc, char** argv)
{
char* video_num_1 = argv[1];
int start_frame = atoi(video_num_1);
char* video_num_2 = argv[2];
int end_frame = atoi(video_num_2);
char* video = argv[3];  // input clip
char* outputdir = argv[4];




	int flag = arg_parse(argc, argv);
	char f1[100];

	////char video[1000];
	char outputfile_INFO[1000];
	char outputfile_TRAJ[1000];
	char outputfile_HOG[1000];
	char outputfile_HOF[1000];
	char outputfile_MBHx[1000];
	char outputfile_MBHy[1000];


	//std::cout<<"eyal-----eyal"<<std::endl;
	//std::cout<<video<<std::endl;
	//std::cout<<outputdir<<std::endl;
	
	//std::cout<<"1"<<std::endl;
	//char* inputdir = "D:\\Eyal\\OpenU\\Computer Science - MSc\\thesis - action recognition\\benchmarks\\ASLAN\\DB";
	//char* inputdir = "E:\\thesis\\ASLAN\\DB";
/////char* inputdir ="H:\\thesis - eating fishes\\DATABASES\\Database-B\\DB_300_HI_RES_Rot_Flip_corrected";



    //char* outputdir = "F:\\thesis-cont\\benchmarks\\ASLAN\\Run_45\\MBH";
    //char* outputdir = "D:\\thesis\\ASLAN\\Run_45\\MBH";
/////char* outputdir ="H:\\thesis - eating fishes\\DATABASES\\Database-B\\Models_300_HI_RES_rot_flip_corrected\\MBH_patch_size=64";
//char* outputdir ="E:\\thesis - eating fishes\\DATABASES\\Database-B\\dummy\\MBH_orig";
	
	

	//for (int i_clip=start_frame; i_clip>=2400; i_clip--){
	for (int i_clip=start_frame; i_clip<=end_frame; i_clip++){
		//itoa(i_clip,f1,10);
		
		sprintf(f1,"%.4d",i_clip);
		/////sprintf(video,"%s\\fish_head-%s.avi",inputdir,f1);
//std::cout<<"2"<<std::endl;
		//printf("video: %s\n",video);
		
		sprintf(outputfile_INFO,"%s\\INFO\\INFO_7-%s.txt",outputdir,f1);
		FILE* info_file= fopen(outputfile_INFO,"w");

		sprintf(outputfile_TRAJ,"%s\\DENSE_TRAJ\\DENSE_TRAJ_7-%s.txt",outputdir,f1);
		FILE* traj_file= fopen(outputfile_TRAJ,"w");

		sprintf(outputfile_HOG,"%s\\HOG\\HOG_7-%s.txt",outputdir,f1);
		FILE* hog_file= fopen(outputfile_HOG,"w");

		sprintf(outputfile_HOF,"%s\\HOF\\HOF_7-%s.txt",outputdir,f1);
		FILE* hof_file= fopen(outputfile_HOF,"w");

		sprintf(outputfile_MBHx,"%s\\MBHx\\MBHx_7-%s.txt",outputdir,f1);
		FILE* mbhx_file= fopen(outputfile_MBHx,"w");

		sprintf(outputfile_MBHy,"%s\\MBHy\\MBHy_7-%s.txt",outputdir,f1);
		FILE* mbhy_file= fopen(outputfile_MBHy,"w");
	
	//std::cout<<"3"<<std::endl;
		do_dense_track(video,flag,info_file,traj_file,hog_file,hof_file,mbhx_file,mbhy_file);

		fclose(info_file);
		fclose(traj_file);
		fclose(hog_file);
		fclose(hof_file);
		fclose(mbhx_file);
		fclose(mbhy_file);
	}
}

int do_dense_track(char* video,int flag,FILE* info_file,FILE* traj_file,FILE* hog_file,FILE* hof_file,FILE* mbhx_file,FILE* mbhy_file){
	bool scale = false;
	VideoCapture capture;
	//int ooo = capture.isOpened();

	//Mat image4;
    //image4 = imread("C:\\Users\\Owner\\Desktop\\Dalia.jpg", CV_LOAD_IMAGE_COLOR);   // Read the file

    //if(! image4.data )                              // Check for invalid input
    //{
    //    //cout <<  "Could not open or find the image" << std::endl ;
    //    return -1;
    //}

    //namedWindow( "Display window", WINDOW_AUTOSIZE );// Create a window for display.
    //imshow( "Display window", image4 );                   // Show our image inside it.

    //waitKey(0); 
//std::cout<<"4"<<std::endl;
	capture.open(video);
	//capture.open("fish_head-0001.avi");
//std::cout<<"5"<<std::endl;
	if(!capture.isOpened()) {
		fprintf(stderr, "Could not initialize capturing..\n");
		return -1;
	}

	int frame_num = 0;
	TrackInfo trackInfo;
	DescInfo hogInfo, hofInfo, mbhInfo;

	InitTrackInfo(&trackInfo, track_length, init_gap);
	InitDescInfo(&hogInfo, 8, false, patch_size, nxy_cell, nt_cell);
	InitDescInfo(&hofInfo, 9, true, patch_size, nxy_cell, nt_cell);
	InitDescInfo(&mbhInfo, 8, false, patch_size, nxy_cell, nt_cell);

	SeqInfo seqInfo;
	InitSeqInfo(&seqInfo, video);

	if(flag)
		seqInfo.length = end_frame - start_frame + 1;

//	fprintf(stderr, "video size, length: %d, width: %d, height: %d\n", seqInfo.length, seqInfo.width, seqInfo.height);

	if(show_track == 1)
		namedWindow("DenseTrack", 0);

	Mat image, prev_grey, grey;

	std::vector<float> fscales(0);
	std::vector<Size> sizes(0);

	std::vector<Mat> prev_grey_pyr(0), grey_pyr(0), flow_pyr(0);
	std::vector<Mat> prev_poly_pyr(0), poly_pyr(0); // for optical flow

	std::vector<std::list<Track> > xyScaleTracks;
	int init_counter = 0; // indicate when to detect new feature points
	while(true) {
		Mat frame;
		int i;
		//, j, 
		int c;

		// get a new frame
		capture >> frame;

		//namedWindow( "Display window", WINDOW_AUTOSIZE );// Create a window for display
		//imshow("farme frame",frame);
		//waitKey(0); 



		if(frame.empty())
			break;

		if(scale){
			std::cout<<"org img size = "<<frame.cols<<"x"<<frame.rows<<std::endl;
			Size size(0,0);
			double xyScale = sqrtf(double(240.0*320.0)/(frame.cols*frame.rows));
			resize(frame,frame,size,xyScale,xyScale);
			std::cout<<"new img size = "<<frame.cols<<"x"<<frame.rows<<std::endl;
		}


		

        //printf("frame_num: %d\n",frame_num);

		if(frame_num < start_frame || frame_num > end_frame) {
			frame_num++;
			continue;
		}

		if(frame_num == start_frame) {
			image.create(frame.size(), CV_8UC3);
			grey.create(frame.size(), CV_8UC1);
			prev_grey.create(frame.size(), CV_8UC1);

			InitPry(frame, fscales, sizes);

			BuildPry(sizes, CV_8UC1, prev_grey_pyr);
			BuildPry(sizes, CV_8UC1, grey_pyr);

			BuildPry(sizes, CV_32FC2, flow_pyr);
			BuildPry(sizes, CV_32FC(5), prev_poly_pyr);
			BuildPry(sizes, CV_32FC(5), poly_pyr);

			xyScaleTracks.resize(scale_num);

			frame.copyTo(image);
			cvtColor(image, prev_grey, CV_BGR2GRAY);

			for(int iScale = 0; iScale < scale_num; iScale++) {
				if(iScale == 0)
					prev_grey.copyTo(prev_grey_pyr[0]);
				else
					resize(prev_grey_pyr[iScale-1], prev_grey_pyr[iScale], prev_grey_pyr[iScale].size(), 0, 0, INTER_LINEAR);

				// dense sampling feature points
				std::vector<Point2f> points(0);
				DenseSample(prev_grey_pyr[iScale], points, quality, min_distance);

				// save the feature points
				std::list<Track>& tracks = xyScaleTracks[iScale];
				for(i = 0; i < points.size(); i++)
					tracks.push_back(Track(points[i], trackInfo, hogInfo, hofInfo, mbhInfo));
			}

			// compute polynomial expansion
			my::FarnebackPolyExpPyr(prev_grey, prev_poly_pyr, fscales, 7, 1.5);

			frame_num++;
			continue;
		}

		init_counter++;
		frame.copyTo(image);
		cvtColor(image, grey, CV_BGR2GRAY);

		// compute optical flow for all scales once
		my::FarnebackPolyExpPyr(grey, poly_pyr, fscales, 7, 1.5);
		my::calcOpticalFlowFarneback(prev_poly_pyr, poly_pyr, flow_pyr, 10, 2);

		for(int iScale = 0; iScale < scale_num; iScale++) {
			if(iScale == 0)
				grey.copyTo(grey_pyr[0]);
			else
				resize(grey_pyr[iScale-1], grey_pyr[iScale], grey_pyr[iScale].size(), 0, 0, INTER_LINEAR);

			int width = grey_pyr[iScale].cols;
			int height = grey_pyr[iScale].rows;

			// compute the integral histograms
			DescMat* hogMat = InitDescMat(height+1, width+1, hogInfo.nBins);

			HogComp(prev_grey_pyr[iScale], hogMat->desc, hogInfo);

			DescMat* hofMat = InitDescMat(height+1, width+1, hofInfo.nBins);

			HofComp(flow_pyr[iScale], hofMat->desc, hofInfo);

			DescMat* mbhMatX = InitDescMat(height+1, width+1, mbhInfo.nBins);

			DescMat* mbhMatY = InitDescMat(height+1, width+1, mbhInfo.nBins);

			MbhComp(flow_pyr[iScale], mbhMatX->desc, mbhMatY->desc, mbhInfo);

			// track feature points in each scale separately
			std::list<Track>& tracks = xyScaleTracks[iScale];
			for (std::list<Track>::iterator iTrack = tracks.begin(); iTrack != tracks.end();) {
				int index = iTrack->index;
				Point2f prev_point = iTrack->point[index];
				int x = std::min<int>(std::max<int>(cvRound(prev_point.x), 0), width-1);
				int y = std::min<int>(std::max<int>(cvRound(prev_point.y), 0), height-1);

				Point2f point;
				point.x = prev_point.x + flow_pyr[iScale].ptr<float>(y)[2*x];
				point.y = prev_point.y + flow_pyr[iScale].ptr<float>(y)[2*x+1];
 
				if(point.x <= 0 || point.x >= width || point.y <= 0 || point.y >= height) {
					iTrack = tracks.erase(iTrack);
					continue;
				}

				// get the descriptors for the feature point
				RectInfo rect;
				GetRect(prev_point, rect, width, height, hogInfo);
				GetDesc(hogMat, rect, hogInfo, iTrack->hog, index);
				GetDesc(hofMat, rect, hofInfo, iTrack->hof, index);
				GetDesc(mbhMatX, rect, mbhInfo, iTrack->mbhX, index);
				GetDesc(mbhMatY, rect, mbhInfo, iTrack->mbhY, index);
				iTrack->addPoint(point);

				// draw the trajectories at the first scale
				if(show_track == 1 && iScale == 0)
					DrawTrack(iTrack->point, iTrack->index, fscales[iScale], image);

				// if the trajectory achieves the maximal length
				if(iTrack->index >= trackInfo.length) {
					std::vector<Point2f> trajectory(trackInfo.length+1);
					for(int i = 0; i <= trackInfo.length; ++i)
						trajectory[i] = iTrack->point[i]*fscales[iScale];
				
					float mean_x(0), mean_y(0), var_x(0), var_y(0), length(0);
					if(IsValid(trajectory, mean_x, mean_y, var_x, var_y, length)) {


					/*

					The first 10 elements are information about the trajectory:

					frameNum:     The trajectory ends on which frame
					mean_x:       The mean value of the x coordinates of the trajectory
					mean_y:       The mean value of the y coordinates of the trajectory
					var_x:        The variance of the x coordinates of the trajectory
					var_y:        The variance of the y coordinates of the trajectory
					length:       The length of the trajectory
					scale:        The trajectory is computed on which scale
					x_pos:        The normalized x position w.r.t. the video (0~0.999), for spatio-temporal pyramid 
					y_pos:        The normalized y position w.r.t. the video (0~0.999), for spatio-temporal pyramid 
					t_pos:        The normalized t position w.r.t. the video (0~0.999), for spatio-temporal pyramid
					The following element are five descriptors concatenated one by one:

					Trajectory:    2x[trajectory length] (default 30 dimension) 
					HOG:           8x[spatial cells]x[spatial cells]x[temporal cells] (default 96 dimension)
					HOF:           9x[spatial cells]x[spatial cells]x[temporal cells] (default 108 dimension)
					MBHx:          8x[spatial cells]x[spatial cells]x[temporal cells] (default 96 dimension)
					MBHy:          8x[spatial cells]x[spatial cells]x[temporal cells] (default 96 dimension)

					*/


						fprintf(info_file, "%d\t%f\t%f\t%f\t%f\t%f\t%f\t", frame_num, mean_x, mean_y, var_x, var_y, length, fscales[iScale]);

						// for spatio-temporal pyramid
						fprintf(info_file,"%f\t", std::min<float>(std::max<float>(mean_x/float(seqInfo.width), 0), 0.999));
						fprintf(info_file,"%f\t", std::min<float>(std::max<float>(mean_y/float(seqInfo.height), 0), 0.999));
						fprintf(info_file,"%f\n", std::min<float>(std::max<float>((frame_num - trackInfo.length/2.0 - start_frame)/float(seqInfo.length), 0), 0.999));
					
						// output the trajectory
						for (int i = 0; i < trackInfo.length; ++i)
							fprintf(traj_file,"%f\t%f\t", trajectory[i].x,trajectory[i].y);
						fprintf(traj_file,"\n");

						PrintDesc(hog_file,iTrack->hog, hogInfo, trackInfo);
						PrintDesc(hof_file,iTrack->hof, hofInfo, trackInfo);
						PrintDesc(mbhx_file,iTrack->mbhX, mbhInfo, trackInfo);
						PrintDesc(mbhy_file,iTrack->mbhY, mbhInfo, trackInfo);
						//printf("frame_num: %d\n",frame_num);
					}

					iTrack = tracks.erase(iTrack);
					continue;
				}
				++iTrack;
			}
			ReleDescMat(hogMat);
			ReleDescMat(hofMat);
			ReleDescMat(mbhMatX);
			ReleDescMat(mbhMatY);

			if(init_counter != trackInfo.gap)
				continue;

			// detect new feature points every initGap frames
			std::vector<Point2f> points(0);
			for(std::list<Track>::iterator iTrack = tracks.begin(); iTrack != tracks.end(); iTrack++)
				points.push_back(iTrack->point[iTrack->index]);

			DenseSample(grey_pyr[iScale], points, quality, min_distance);
			// save the new feature points
			for(i = 0; i < points.size(); i++)
				tracks.push_back(Track(points[i], trackInfo, hogInfo, hofInfo, mbhInfo));
		}

		init_counter = 0;
		grey.copyTo(prev_grey);
		for(i = 0; i < scale_num; i++) {
			grey_pyr[i].copyTo(prev_grey_pyr[i]);
			poly_pyr[i].copyTo(prev_poly_pyr[i]);
		}

		frame_num++;

		if( show_track == 1 ) {
			imshow( "DenseTrack", image);
			c = cvWaitKey(3);
			if((char)c == 27) break;
		}
	}

	if( show_track == 1 )
		destroyWindow("DenseTrack");

	return 0;
}
