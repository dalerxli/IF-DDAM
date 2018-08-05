      subroutine objetparanxnynzsurf(trope,eps,epsani,eps0,xs,ys,zs,xswf
     $     ,yswf,zswf,k0 ,aretecube,tabdip,nnnr,nmax,nbsphere,ndipole,nx
     $     ,ny,nz,nxm,nym,nzm,nxmp,nymp,nzmp,methode ,epsilon,polarisa
     $     ,sidex,sidey,sidez,xg,yg,zg,na ,neps,nepsmax,dcouche,zcouche
     $     ,epscouche,tabzn,nmat,infostr,nstop)
      implicit none
      integer nmax,tabdip(nmax),nbsphere,ndipole,nx,ny,nz,nxm,nym,nzm,ii
     $     ,jj,i,j,k,test,IP(3),nnnr,dddis,inv,na,nstop,nxmp,nymp,nzmp
     $     ,nmat
      double precision xs(nmax),ys(nmax),zs(nmax),xswf(nmax),yswf(nmax)
     $     ,zswf(nmax),k0,xg,yg,zg,x,y,z ,aretecube,sidex,sidey,sidez
     $     ,side,pi,z1,z2
      double complex eps,epsani(3,3),polaeps(3,3),polarisa(nmax,3,3)
     $     ,epsilon(nmax,3,3),ctmp

      integer neps,nepsmax,nminc,nmaxc,numerocouche,tabzn(nmax)
      double precision dcouche(nepsmax),zcouche(0:nepsmax),zmin,zmax
      double complex epscouche(0:nepsmax+1),eps0

      
      character(2) methode
      character(3) trope
      character(64) infostr

      write(*,*) 'cuboid::nmax=',nmax

c     Initialization
      nbsphere=0
      ndipole=0 
      Tabdip=0
      Tabzn=0
      polarisa=0.d0
      write(*,*) 'cuboid2',nmax
      epsilon=0.d0
      dddis=1
      inv=1
      pi=dacos(-1.d0)
      
c     mesh 
      open(20,file='x.mat')
      open(21,file='y.mat')
      open(22,file='z.mat')  
c     discretization of the object under study
      open(10,file='xc.mat')
      open(11,file='yc.mat')
      open(12,file='zc.mat')  

      nx=nxm-2*nxmp
      ny=nym-2*nymp
      nz=nzm-2*nzmp
      aretecube=aretecube*1.d-9
      sidex=aretecube*dble(nx)
      sidey=aretecube*dble(ny)
      sidez=aretecube*dble(nz)
      xg=xg*1.d-9
      yg=yg*1.d-9
      zg=zg*1.d-9
      
      if (sidex.eq.0.d0) then
         nstop=1
         infostr='object cuboid: sidex=0!'
         return
      elseif (sidey.eq.0.d0) then
         nstop=1
         infostr='object cuboid: sidey=0!'
         return
      elseif (sidez.eq.0.d0) then
         nstop=1
         infostr='object cuboid: sidez=0!'
         return
      endif


      if (nx.gt.nxm.or.ny.gt.nym.or.nz.gt.nzm) then
         nstop=1
         infostr='Dimension Problem of the Box : Box too small!'
         write(99,*) 'dimension Problem',nx,nxm,ny,nym,nz,nzm
         write(*,*) 'dimension Problem',nx,nxm,ny,nym,nz,nzm
         return
      endif

c     deplacement des couches.
      z1=zg-sidez/2.d0
      z2=zg+sidez/2.d0
      nminc=numerocouche(z1,neps,nepsmax,zcouche)
      nmaxc=numerocouche(z2,neps,nepsmax,zcouche)
      write(*,*) 'zcouche',zcouche,nminc,nmaxc
      if (nmaxc-nminc.ge.1) then
c     shift the layers
         do k=nminc,nmaxc-1           
            do i=1,nnnr
               z=-sidez/2.d0+aretecube*(dble(i)-0.5d0)+zg
               if (zcouche(k).ge.z.and.zcouche(k).lt.z+aretecube) then
                  zcouche(k)=z+aretecube/2.d0
               endif              
            enddo
         enddo
      endif
      write(*,*) 'zcouche',zcouche,nx,ny,nz
      
      do i=1,nz
         do j=1,ny
            do k=1,nx

               x=aretecube*(dble(k)-0.5d0)-sidex/2.d0
               y=aretecube*(dble(j)-0.5d0)-sidey/2.d0
               z=aretecube*(dble(i)-0.5d0)-sidez/2.d0
               
               if (j.eq.1.and.k.eq.1) write(22,*) z+zg
               if (i.eq.1.and.k.eq.1) write(21,*) y+yg
               if (j.eq.1.and.i.eq.1) write(20,*) x+xg

               ndipole=ndipole+1  
               nbsphere=nbsphere+1
               Tabdip(ndipole)=nbsphere
               xs(nbsphere)=x+xg
               ys(nbsphere)=y+yg
               zs(nbsphere)=z+zg
               xswf(ndipole)=x+xg
               yswf(ndipole)=y+yg
               zswf(ndipole)=z+zg
               Tabzn(ndipole)=i
               write(*,*) 'jjj',i,j,k,x,y,z,eps,eps0
               eps0=epscouche(numerocouche(zs(nbsphere),neps ,nepsmax
     $              ,zcouche))
               if (trope.eq.'iso') then
                  call poladiffcomp(aretecube,eps,eps0,k0,dddis ,methode
     $                 ,ctmp)  
                  polarisa(nbsphere,1,1)=ctmp
                  polarisa(nbsphere,2,2)=ctmp
                  polarisa(nbsphere,3,3)=ctmp
                  epsilon(nbsphere,1,1)=eps
                  epsilon(nbsphere,2,2)=eps
                  epsilon(nbsphere,3,3)=eps
               else
                  call polaepstenscomp(aretecube,epsani,eps0,k0
     $                 ,dddis,methode,inv,polaeps)
                  do ii=1,3
                     do jj=1,3
                        epsilon(nbsphere,ii,jj)=epsani(ii,jj)
                        polarisa(nbsphere,ii,jj)=polaeps(ii,jj)
                     enddo
                  enddo
               endif
               if (nmat.eq.0) then
                  write(10,*) xs(nbsphere)
                  write(11,*) ys(nbsphere)
                  write(12,*) zs(nbsphere)
               endif 
            enddo
         enddo
      enddo

      if (ndipole.gt.nmax) then
         infostr='nmax parameter too small: increase nxm nym nzm'
         nstop=1
         return
      endif

      close(10)
      close(11)
      close(12)
      close(20)
      close(21)
      close(22)
      write(*,*) 'cuboid::nbsphere=',nbsphere
      end
