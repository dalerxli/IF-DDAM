      subroutine objetellipsesurf(trope,eps,epsani,eps0,xs,ys,zs,xswf
     $     ,yswf,zswf,k0,aretecube,tabdip,nnnr,nmax,nbsphere,ndipole,nx
     $     ,ny,nz,nxm,nym,nzm,methode,na,epsilon,polarisa,a,b,c,xg,yg,zg
     $     ,phi,theta ,psi,neps,nepsmax,dcouche ,zcouche,epscouche,tabzn
     $     ,infostr ,nstop)
      
      implicit none
      integer nmax,tabdip(nmax),nbsphere,ndipole,nx,ny,nz,nxm,nym,nzm,ii
     $     ,jj,i,j,k,test,IP(3),nnnr,dddis,inv,na,nstop
      double precision xs(nmax),ys(nmax),zs(nmax),xswf(nmax),yswf(nmax)
     $     ,zswf(nmax),k0,xg,yg,zg,x,y,z ,aretecube,xr,yr,zr,pi,x1,x2,y1
     $     ,y2,z1,z2
      double complex eps,epsani(3,3),polaeps(3,3),polarisa(nmax,3,3)
     $     ,epsilon(nmax,3,3),ctmp

      double precision a,b,c,demim,theta,phi,psi,mat(3,3)

      integer neps,nepsmax,nminc,nmaxc,numerocouche,tabzn(nmax)
      double precision dcouche(nepsmax),zcouche(0:nepsmax),zmin,zmax
      double complex epscouche(0:nepsmax+1),eps0
      
      character(2) methode
      character(3) trope
      character(64) infostr

c     Initialization
      nbsphere=0
      ndipole=0 
      Tabdip=0
      polarisa=0.d0
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

      a=a*1.d-9
      b=b*1.d-9
      c=c*1.d-9
      xg=xg*1.d-9
      yg=yg*1.d-9
      zg=zg*1.d-9
      theta=theta*pi/180.d0
      phi=phi*pi/180.d0
      psi=psi*pi/180.d0

      demim=max(a,b,c)
      if (a.eq.0.d0) then
         nstop=1
         infostr='object ellipse: a=0!'
         return
      endif
      if (b.eq.0.d0) then
         nstop=1
         infostr='object ellipse: b=0!'
         return
      endif
      if (c.eq.0.d0) then
         nstop=1
         infostr='object ellipse: c=0!'
         return
      endif
      mat(1,1)=dcos(psi)*dcos(phi)-dsin(psi)*dcos(theta)*dsin(phi)
      mat(1,2)=-dcos(psi)*dsin(phi)-dsin(psi)*dcos(theta)*dcos(phi)
      mat(1,3)=dsin(psi)*dsin(theta)
      
      mat(2,1)=dsin(psi)*dcos(phi)+dcos(psi)*dcos(theta)*dsin(phi)
      mat(2,2)=-dsin(psi)*dsin(phi)+dcos(psi)*dcos(theta)*dcos(phi)
      mat(2,3)=-dcos(psi)*dsin(theta)

      mat(3,1)=dsin(theta)*dsin(phi)
      mat(3,2)=dsin(theta)*dcos(phi)
      mat(3,3)=dcos(theta)

c      mat(1,1)=dcos(theta)*dcos(psi)
c      mat(1,2)=-dcos(phi)*dsin(psi)+dsin(phi)*dsin(theta)*dcos(psi)
c      mat(1,3)=dsin(phi)*dsin(psi)+dcos(phi)*dsin(theta)*dcos(psi)
c      mat(2,1)=dcos(theta)*sin(psi)
c      mat(2,2)=dcos(phi)*dcos(psi)+dsin(phi)*dsin(theta)*dsin(psi)
c      mat(2,3)=-dsin(phi)*dcos(psi)+dcos(phi)*dsin(theta)*dsin(psi)
c      mat(3,1)=-dsin(theta)
c      mat(3,2)=dsin(phi)*dcos(theta)
c      mat(3,3)=dcos(phi)*dcos(theta)

c      call inversemat33r(mat)

c      aretecube=2.d0*demim/dble(nnnr)

      x1=1.d30
      x2=-1.d30
      y1=1.d30
      y2=-1.d30
      z1=1.d30
      z2=-1.d30

      x=-a
      y=-b
      z=-c
      xr=mat(1,1)*x+mat(1,2)*y+mat(1,3)*z
      yr=mat(2,1)*x+mat(2,2)*y+mat(2,3)*z
      zr=mat(3,1)*x+mat(3,2)*y+mat(3,3)*z
      x1=min(x1,xr)
      x2=max(x2,xr)
      y1=min(y1,yr)
      y2=max(y2,yr)
      z1=min(z1,zr)
      z2=max(z2,zr)

      x=a
      y=-b
      z=-c
      xr=mat(1,1)*x+mat(1,2)*y+mat(1,3)*z
      yr=mat(2,1)*x+mat(2,2)*y+mat(2,3)*z
      zr=mat(3,1)*x+mat(3,2)*y+mat(3,3)*z
      x1=min(x1,xr)
      x2=max(x2,xr)
      y1=min(y1,yr)
      y2=max(y2,yr)
      z1=min(z1,zr)
      z2=max(z2,zr)

      x=-a
      y=b
      z=-c
      xr=mat(1,1)*x+mat(1,2)*y+mat(1,3)*z
      yr=mat(2,1)*x+mat(2,2)*y+mat(2,3)*z
      zr=mat(3,1)*x+mat(3,2)*y+mat(3,3)*z
      x1=min(x1,xr)
      x2=max(x2,xr)
      y1=min(y1,yr)
      y2=max(y2,yr)
      z1=min(z1,zr)
      z2=max(z2,zr)

      x=-a
      y=-b
      z=c
      xr=mat(1,1)*x+mat(1,2)*y+mat(1,3)*z
      yr=mat(2,1)*x+mat(2,2)*y+mat(2,3)*z
      zr=mat(3,1)*x+mat(3,2)*y+mat(3,3)*z
      x1=min(x1,xr)
      x2=max(x2,xr)
      y1=min(y1,yr)
      y2=max(y2,yr)
      z1=min(z1,zr)
      z2=max(z2,zr)

      x=a
      y=b
      z=-c
      xr=mat(1,1)*x+mat(1,2)*y+mat(1,3)*z
      yr=mat(2,1)*x+mat(2,2)*y+mat(2,3)*z
      zr=mat(3,1)*x+mat(3,2)*y+mat(3,3)*z
      x1=min(x1,xr)
      x2=max(x2,xr)
      y1=min(y1,yr)
      y2=max(y2,yr)
      z1=min(z1,zr)
      z2=max(z2,zr)


      x=a
      y=-b
      z=c
      xr=mat(1,1)*x+mat(1,2)*y+mat(1,3)*z
      yr=mat(2,1)*x+mat(2,2)*y+mat(2,3)*z
      zr=mat(3,1)*x+mat(3,2)*y+mat(3,3)*z
      x1=min(x1,xr)
      x2=max(x2,xr)
      y1=min(y1,yr)
      y2=max(y2,yr)
      z1=min(z1,zr)
      z2=max(z2,zr)

      x=-a
      y=b
      z=c
      xr=mat(1,1)*x+mat(1,2)*y+mat(1,3)*z
      yr=mat(2,1)*x+mat(2,2)*y+mat(2,3)*z
      zr=mat(3,1)*x+mat(3,2)*y+mat(3,3)*z
      x1=min(x1,xr)
      x2=max(x2,xr)
      y1=min(y1,yr)
      y2=max(y2,yr)
      z1=min(z1,zr)
      z2=max(z2,zr)

      x=a
      y=b
      z=c
      xr=mat(1,1)*x+mat(1,2)*y+mat(1,3)*z
      yr=mat(2,1)*x+mat(2,2)*y+mat(2,3)*z
      zr=mat(3,1)*x+mat(3,2)*y+mat(3,3)*z
      write(*,*) 'r',xr,yr,zr,xr*xr+yr*yr+zr*zr
      x1=min(x1,xr)
      x2=max(x2,xr)
      y1=min(y1,yr)
      y2=max(y2,yr)
      z1=min(z1,zr)
      z2=max(z2,zr)
      write(*,*) x1,x2,y1,y2,z1,z2
      demim=max(x2-x1,y2-y1,z2-z1)/2.d0
      aretecube=2.d0*demim/dble(nnnr)
      call inversemat33r(mat)
    
c     boite au plus pres de l'objet
      nx=int((x2-x1)/aretecube)
      ny=int((y2-y1)/aretecube)
      nz=int((z2-z1)/aretecube)
      write(*,*) 'nnn',nx,ny,nz

      if (nx.gt.nxm.or.ny.gt.nym.or.nz.gt.nzm) then
         nstop=1
         infostr='Dimension Problem of the Box : Box too small!'
         write(99,*) 'dimension Problem',nx,nxm,ny,nym,nz,nzm
         write(*,*) 'dimension Problem',nx,nxm,ny,nym,nz,nzm
         return
      endif

c     deplacement des couches.

      nminc=numerocouche(z1,neps,nepsmax,zcouche)
      nmaxc=numerocouche(z2,neps,nepsmax,zcouche)
      if (nmaxc-nminc.ge.1) then
c     shift the layers
         do k=nminc,nmaxc-1           
            do i=1,nnnr
               z=-demim+aretecube*(dble(i)-0.5d0)+zg
               if (zcouche(k).ge.z.and.zcouche(k).lt.z+aretecube) then
                  zcouche(k)=z+aretecube/2.d0
               endif              
            enddo
         enddo
      endif

      

      if (na.eq.-1) then
         do i=1,nz
            do j=1,ny
               do k=1,nx

                  x=-(x2-x1)/2.d0+aretecube*(dble(k)-0.5d0)
                  y=-(y2-y1)/2.d0+aretecube*(dble(j)-0.5d0)
                  z=-(z2-z1)/2.d0+aretecube*(dble(i)-0.5d0)

                  if (j.eq.1.and.k.eq.1) write(22,*) z+zg
                  if (i.eq.1.and.k.eq.1) write(21,*) y+yg
                  if (j.eq.1.and.i.eq.1) write(20,*) x+xg

                  ndipole=ndipole+1
                  xswf(ndipole)=x+xg
                  yswf(ndipole)=y+yg
                  zswf(ndipole)=z+zg
                  Tabzn(ndipole)=i
                  
                  xr=mat(1,1)*x+mat(1,2)*y+mat(1,3)*z
                  yr=mat(2,1)*x+mat(2,2)*y+mat(2,3)*z
                  zr=mat(3,1)*x+mat(3,2)*y+mat(3,3)*z

                  if (xr*xr/a/a+yr*yr/b/b+zr*zr/c/c.le.1.d0) then
                     nbsphere=nbsphere+1
                     Tabdip(ndipole)=nbsphere
                     xs(nbsphere)=x+xg
                     ys(nbsphere)=y+yg
                     zs(nbsphere)=z+zg
                     eps0=epscouche(numerocouche(zs(nbsphere),neps
     $                    ,nepsmax,zcouche))
                     if (trope.eq.'iso') then
                        call poladiffcomp(aretecube,eps,eps0,k0,dddis
     $                       ,methode,ctmp)  
                        polarisa(nbsphere,1,1)=ctmp
                        polarisa(nbsphere,2,2)=ctmp
                        polarisa(nbsphere,3,3)=ctmp
                        epsilon(nbsphere,1,1)=eps
                        epsilon(nbsphere,2,2)=eps
                        epsilon(nbsphere,3,3)=eps

                     else
                        call polaepstenscomp(aretecube,epsani,eps0,k0
     $                       ,dddis,methode,inv,polaeps)
                        do ii=1,3
                           do jj=1,3
                              epsilon(nbsphere,ii,jj)=epsani(ii,jj)
                              polarisa(nbsphere,ii,jj)=polaeps(ii,jj)
                           enddo
                        enddo
                     endif
                     write(10,*) xs(nbsphere)
                     write(11,*) ys(nbsphere)
                     write(12,*) zs(nbsphere)
                  endif
               enddo
            enddo
         enddo
      elseif (na.eq.0) then
         do i=1,nz
            do j=1,ny
               do k=1,nx
                  x=-(x2-x1)/2.d0+aretecube*(dble(k)-0.5d0)
                  y=-(y2-y1)/2.d0+aretecube*(dble(j)-0.5d0)
                  z=-(z2-z1)/2.d0+aretecube*(dble(i)-0.5d0)
   
                  if (j.eq.1.and.k.eq.1) write(22,*) z+zg
                  if (i.eq.1.and.k.eq.1) write(21,*) y+yg
                  if (j.eq.1.and.i.eq.1) write(20,*) x+xg

                  ndipole=ndipole+1
                  nbsphere=nbsphere+1
                  Tabdip(ndipole)=nbsphere
                  xswf(ndipole)=x+xg
                  yswf(ndipole)=y+yg
                  zswf(ndipole)=z+zg
                  Tabzn(ndipole)=i
                  
                  xr=mat(1,1)*x+mat(1,2)*y+mat(1,3)*z
                  yr=mat(2,1)*x+mat(2,2)*y+mat(2,3)*z
                  zr=mat(3,1)*x+mat(3,2)*y+mat(3,3)*z

                  if (xr*xr/a/a+yr*yr/b/b+zr*zr/c/c.le.1.d0) then
                     
                     xs(nbsphere)=x+xg
                     ys(nbsphere)=y+yg
                     zs(nbsphere)=z+zg
                     eps0=epscouche(numerocouche(zs(nbsphere),neps
     $                    ,nepsmax,zcouche))
                     if (trope.eq.'iso') then
                        call poladiffcomp(aretecube,eps,eps0,k0,dddis
     $                       ,methode,ctmp)  
                        polarisa(nbsphere,1,1)=ctmp
                        polarisa(nbsphere,2,2)=ctmp
                        polarisa(nbsphere,3,3)=ctmp
                        epsilon(nbsphere,1,1)=eps
                        epsilon(nbsphere,2,2)=eps
                        epsilon(nbsphere,3,3)=eps
                     else
                        call polaepstenscomp(aretecube,epsani,eps0,k0
     $                       ,dddis,methode,inv,polaeps)
                        do ii=1,3
                           do jj=1,3
                              epsilon(nbsphere,ii,jj)=epsani(ii,jj)
                              polarisa(nbsphere,ii,jj)=polaeps(ii,jj)
                           enddo
                        enddo
                     endif
                     write(10,*) xs(nbsphere)
                     write(11,*) ys(nbsphere)
                     write(12,*) zs(nbsphere)
                  else
                     xs(nbsphere)=x+xg
                     ys(nbsphere)=y+yg
                     zs(nbsphere)=z+zg
                     eps0=epscouche(numerocouche(zs(nbsphere),neps
     $                    ,nepsmax,zcouche))
                     epsilon(nbsphere,1,1)=eps0
                     epsilon(nbsphere,2,2)=eps0
                     epsilon(nbsphere,3,3)=eps0                    
                     write(10,*) xs(nbsphere)
                     write(11,*) ys(nbsphere)
                     write(12,*) zs(nbsphere)
                  endif
               enddo
            enddo
         enddo
      else
         infostr='na should be equal to -1 or 0'
         nstop=1
         return
      endif
      if (ndipole.gt.nmax) then
         infostr='nmax parameter too small: increase nxm nym nzm'
         nstop=1
         return
      endif
      close(10)
      close(11)
      close(12)
      close(15)
      close(20)
      close(21)
      close(22)

      end
