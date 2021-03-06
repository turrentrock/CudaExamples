#include <iostream>
#include <string>

#include <cudaErrors.h>

__global__ void alligned_access(float* a,int max){
	int idx = blockIdx.x*blockDim.x + threadIdx.x;
	if (idx >= max) return;
	a[idx] = a[idx] + 1;
}

__global__ void offset_access(float* a,int s,int max){
	int idx = blockIdx.x*blockDim.x + threadIdx.x;
	if (idx+s >= max) return;
	a[idx+s] = a[idx+s] + 1;
}

__global__ void strided_access(float* a,int s,int max){
	int idx = blockIdx.x*blockDim.x + threadIdx.x;
	if (idx*s >= max) return;
	a[idx*s] = a[idx*s] + 1;
}

int main(int argc,char** argv){

	int max_threads=1024;
	int max_blocks=128;
	int max_stride=10;
	int max_mem = max_stride*max_threads*max_blocks;

	dim3 blocks(max_blocks);
	dim3 threads(max_threads);

	float *a;
	checkCudaErrors(cudaMallocManaged((void **)&a, max_mem*sizeof(*a)));

	for(int i=0;i<max_mem;i++) a[i]=0;

	switch(argv[1][0]){
	case '0':
		alligned_access<<<blocks,threads>>>(a,max_mem);
		checkCudaErrors(cudaGetLastError());
		checkCudaErrors(cudaDeviceSynchronize());
		break;

	case '1':
		offset_access<<<blocks,threads>>>(a,3,max_mem);
		checkCudaErrors(cudaGetLastError());
		checkCudaErrors(cudaDeviceSynchronize());
		break;

	case '2':
		strided_access<<<blocks,threads>>>(a,max_stride,max_mem);
		checkCudaErrors(cudaGetLastError());
		checkCudaErrors(cudaDeviceSynchronize());
		break;
	}

	checkCudaErrors(cudaFree(a));

	return 0;
}