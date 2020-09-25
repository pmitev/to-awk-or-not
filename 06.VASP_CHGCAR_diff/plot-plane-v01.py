#!/usr/bin/env python
# Author: Pavlin Mitev 
# version 2015.10.22
import numpy as np
import os,sys,time
from math import sin, cos, degrees, radians
from ase import Atoms
from ase.calculators.vasp import VaspChargeDensity

import scipy.ndimage as ndimage

import matplotlib.pyplot as plt

#import scipy.interpolate as interpolate
#from scipy.interpolate import griddata

#======================================
atom1= 2 # atom in the center
atom2= 1 # atom from the plane
atom3= 0 # second atom in the plain

npx= 90 # number of point to sample the plane in x
npy= 90 # number of point to sample the plane in y

angle= radians(-144) # rotate the final plot around the central atom
#angle= radians(0)


start= time.time()
sys.stdout.write("Reading CHGCAR... "); sys.stdout.flush()
CHGCAR= VaspChargeDensity("CHGCAR")
end= time.time()
print "finished. {0}".format(end-start)


cell= CHGCAR.atoms[0].cell
nx,ny,nz= np.shape(CHGCAR.chg[0])
ncell= cell/np.array([nx,ny,nz])


# define plane =================================
p1= CHGCAR.atoms[0].get_scaled_positions()[atom1]    
p2= CHGCAR.atoms[0].get_scaled_positions()[atom2]     
p3= CHGCAR.atoms[0].get_scaled_positions()[atom3]    

# get normal to the plane
v1= p2-p1; 
v2= p3-p1; 

v1n= np.dot(v1,cell);        # v1 in Cartesian
v2n= np.dot(v2,cell);        # v2 in Cartesian

v1n= v1n/np.linalg.norm(v1n) # v1 unit in Cartesian
v2n= v2n/np.linalg.norm(v2n) # v2 unit in Cartesian

vnorm= np.cross(v1n,v2n);
vnorm= vnorm/np.linalg.norm(vnorm)
#vnorm= np.dot(vnorm,cell)    # vnorm in Cartesian

# Rotate the plane ==============================
axis = vnorm;
axis_skewed = [ [0, -axis[2], axis[1]], [ axis[2], 0, -axis[0] ] , [ -axis[1], axis[0], 0] ];
R = np.eye(3) + np.dot(sin(angle),axis_skewed) + (1-cos(angle))*np.dot(axis_skewed,axis_skewed);
v1n= np.dot(v1n,R)

v2n= np.cross(vnorm,v1n);     # v2 is a vector in the same plane but perpendicular to v1n
v2n= v2n/np.linalg.norm(v2n)

v1n= np.dot(v1n,np.linalg.inv(cell)) # back to fractional
v2n= np.dot(v2n,np.linalg.inv(cell)) # back to fractional


grid= np.zeros((npx*npy,3))
ip= 0
for ix in np.linspace(-1.5,1.5,npx):
  for iy in np.linspace(-1.5,1.5,npy):
    grid[ip]= (v1n*ix + v2n*iy + p1)*[nx,ny,nz]
    ip= ip + 1 

grid_x, grid_y, grid_z= grid[:,0], grid[:,1], grid[:,2]
plane= ndimage.map_coordinates(CHGCAR.chg[0],[grid_x, grid_y, grid_z], mode="wrap")
px,py=np.mgrid[-1.5:1.5:npx+0j,-1.5:1.5:npy+0j]


plt.rcParams["figure.figsize"]=[ 8,8]

plt.plot([0],[0],'ko',ms=9 )

plt.plot( np.dot(np.dot(v1,cell),np.dot(v1n,cell)) , np.dot(np.dot(v1,cell),np.dot(v2n,cell)) , 'ko',ms=9 )
#plt.text( np.dot(np.dot(v1,cell),np.dot(v1n,cell)) , np.dot(np.dot(v1,cell),np.dot(v2n,cell))-0.1 , 'p1', alpha= 0.2)

plt.plot( np.dot(np.dot(v2,cell),np.dot(v1n,cell)) , np.dot(np.dot(v2,cell),np.dot(v2n,cell)) , 'ko',ms=9 )
#plt.text( np.dot(np.dot(v2,cell),np.dot(v1n,cell)) , np.dot(np.dot(v2,cell),np.dot(v2n,cell))-0.1 , 'p2', alpha= 0.2) 

#CIM1= plt.imshow(plane.reshape(npx,npy).T, origin='lower', extent=(-1.5, 1.5, -1.5, 1.5), alpha=0.4, cmap='spectral')
CIM1= plt.imshow(plane.reshape(npx,npy).T, origin='lower', extent=(-1.5, 1.5, -1.5, 1.5), alpha=1, vmin=-.2,vmax=.2, cmap='bwr')

#plt.contour(px,py,plane.reshape(npx,npy))
CL1= plt.contour(px,py,plane.reshape(npx,npy),np.arange(0.05,10,0.02), colors=["black"])
CL2= plt.contour(px,py,plane.reshape(npx,npy),[0], colors=["red"])
CL3= plt.contour(px,py,plane.reshape(npx,npy),np.arange(-0.05,-10,-0.02), colors=["blue"])


plt.grid(True)
plt.tick_params(size=10,width=1.5,pad=20, labelsize=22)

plt.savefig("CHGCAR.ps")

plt.ion()
plt.show()







