      subroutine objetnspheressurf(trope,epss,epsanis,numbersphere
     $     ,numberspheremax,xg,yg,zg,rayons,eps0,xs,ys,zs,xswf,yswf
     $     ,zswf ,k0,aretecube ,tabdip,tabnbs,nnnr,nmax,nbsphere,ndipole
     $     ,nx ,ny,nz,methode ,na,epsilon,polarisa,neps,nepsmax,dcouche
     $     ,zcouche,epscouche ,tabzn,infostr,nstop)
      implicit none
      integer nmax,tabdip(nmax),tabnbs(nmax),nbsphere,ndipole,nx,ny,nz
     $     ,na,ii,jj,i,j,k,test,IP(3),nnnr,dddis,inv,is,numbersphere
     $     ,numberspheremax,nstop
      double precision xs(nmax),ys(nmax),zs(nmax),xswf(nmax),yswf(nmax)
     $     ,zswf(nmax),k0,xg(numberspheremax) ,yg(numberspheremax)
     $     ,zg(numberspheremax),x,y,z,aretecube ,rayons(numberspheremax)
     $     ,xmin,xmax,ymin,ymax,zmin,zmax
      double complex eps,epsani(3,3),polaeps(3,3),polarisa(nmax,3,3)
     $     ,epsilon(nmax,3,3),epss(numberspheremax)
     $     ,epsanis(numberspheremax,3,3),ctmp

      integer neps,nepsmax,nminc,nmaxc,numerocouche,tabzn(nmax)
      double precision dcouche(nepsmax),zcouche(0:nepsmax)
      double complex epscouche(0:nepsmax+1),eps0
      
      character(2) methode
      character(3) trope
      character(64) infostr

c     Initialization
      nbsphere=0
      ndipole=0 
      Tabdip=0
      Tabzn=0
      tabnbs=0
      polarisa=0.d0
      epsilon=0.d0
      dddis=1
      inv=1

 
      xmax=-1.d300
      xmin=1.d300
      ymax=-1.d300
      ymin=1.d300
      zmax=-1.d300
      zmin=1.d300
c     mesh 
      open(20,file='x.mat')
      open(21,file='y.mat')
      open(22,file='z.mat')  
c     discretization of the object under study
      open(10,file='xc.mat')
      open(11,file='yc.mat')
      open(12,file='zc.mat')  

      
      
      do is=1,numbersphere
         rayons(is)=rayons(is)*1.d-9
         xg(is)=xg(is)*1.d-9
         yg(is)=yg(is)*1.d-9
         zg(is)=zg(is)*1.d-9
         xmax=max(xmax,xg(is)+rayons(is))
         xmin=min(xmin,xg(is)-rayons(is))
         ymax=max(ymax,yg(is)+rayons(is))
         ymin=min(ymin,yg(is)-rayons(is))
         zmax=max(zmax,zg(is)+rayons(is))
         zmin=min(zmin,zg(is)-rayons(is))
         if (rayons(is).eq.0.d0) then
            nstop=1
            infostr='object nspheres: radius=0!'
            return
         endif
      enddo
      if (numbersphere.gt.numberspheremax) then
         infostr='number of spheres too large: limited to 20'
         nstop=1
         return
      endif
      aretecube=max(zmax-zmin,ymax-ymin,xmax-xmin)/dble(nnnr)


      nx=idnint((xmax-xmin)/aretecube)
      ny=idnint((ymax-ymin)/aretecube)
      nz=idnint((zmax-zmin)/aretecube)

      nminc=numerocouche(zmin,neps,nepsmax,zcouche)
      nmaxc=numerocouche(zmax,neps,nepsmax,zcouche)
      
      if (nmaxc-nminc.ge.1) then
c     shift the layers
         do k=nminc,nmaxc-1           
            do i=1,nnnr
               z=zmin+dble(i-1)*aretecube+aretecube/2.d0
               if (zcouche(k).ge.z.and.zcouche(k).lt.z+aretecube) then
                  zcouche(k)=z+aretecube/2.d0
               endif              
            enddo
         enddo
      endif

      
      write(*,*) 'Box including the N spheres',nx,ny,nz,aretecube,na
     $     ,numbersphere
c      write(*,*) 'X',xmin*1.d9,xmax*1.d9
c      write(*,*) 'Y',ymin*1.d9,ymax*1.d9
c      write(*,*) 'Z',zmin*1.d9,zmax*1.d9
      if (na.eq.-1) then
         do i=1,nz
            do j=1,ny
               do k=1,nx
                  x=xmin+dble(k-1)*aretecube+aretecube/2.d0
                  y=ymin+dble(j-1)*aretecube+aretecube/2.d0
                  z=zmin+dble(i-1)*aretecube+aretecube/2.d0

                  if (j.eq.1.and.k.eq.1) write(22,*) z
                  if (i.eq.1.and.k.eq.1) write(21,*) y
                  if (j.eq.1.and.i.eq.1) write(20,*) x

                  ndipole=ndipole+1
                  xswf(ndipole)=x
                  yswf(ndipole)=y
                  zswf(ndipole)=z
                  Tabzn(ndipole)=i
                  test=0
                  do is=1,numbersphere
                     if ((x-xg(is))**2+(y-yg(is))**2+(z-zg(is))
     $                    **2.le.rayons(is)**2) then
                        test=test+1
                        nbsphere=nbsphere+1
                        Tabdip(ndipole)=nbsphere
                        Tabnbs(nbsphere)=is
                        xs(nbsphere)=x
                        ys(nbsphere)=y
                        zs(nbsphere)=z
                        eps0=epscouche(numerocouche(zs(nbsphere),neps
     $                       ,nepsmax,zcouche))
                        if (trope.eq.'iso') then
                           eps=epss(is)
                           call poladiffcomp(aretecube,eps,eps0,k0,dddis
     $                          ,methode,ctmp)  
                           polarisa(nbsphere,1,1)=ctmp
                           polarisa(nbsphere,2,2)=ctmp
                           polarisa(nbsphere,3,3)=ctmp
                           epsilon(nbsphere,1,1)=eps
                           epsilon(nbsphere,2,2)=eps
                           epsilon(nbsphere,3,3)=eps
                        else
                           do ii=1,3
                              do jj=1,3
                                 epsani(ii,jj)=epsanis(is,ii,jj)
                                 epsilon(nbsphere,ii,jj)=epsani(ii,jj)
                              enddo
                           enddo
                           call polaepstenscomp(aretecube,epsani,eps0,k0
     $                          ,dddis,methode,inv,polaeps)
                           do ii=1,3
                              do jj=1,3
                                 polarisa(nbsphere,ii,jj)=polaeps(ii,jj)
                              enddo
                           enddo
                        endif
                        write(10,*) xs(nbsphere)
                        write(11,*) ys(nbsphere)
                        write(12,*) zs(nbsphere)
                     endif
                  enddo
                  if (test.eq.2) then
                     infostr='sphere are not distincts'
                     nstop=1
                     return
                  endif
               enddo
            enddo
         enddo
      elseif (na.eq.0) then
         do i=1,nz
            do j=1,ny
               do k=1,nx
                  x=xmin+dble(k-1)*aretecube+aretecube/2.d0
                  y=ymin+dble(j-1)*aretecube+aretecube/2.d0
                  z=zmin+dble(i-1)*aretecube+aretecube/2.d0

                  if (j.eq.1.and.k.eq.1) write(22,*) z
                  if (i.eq.1.and.k.eq.1) write(21,*) y
                  if (j.eq.1.and.i.eq.1) write(20,*) x

                  ndipole=ndipole+1
                  nbsphere=nbsphere+1
                  Tabdip(ndipole)=nbsphere
                  xswf(ndipole)=x
                  yswf(ndipole)=y
                  zswf(ndipole)=z
                  Tabzn(ndipole)=i
                  test=0
                  do is=1,numbersphere
                     if ((x-xg(is))**2+(y-yg(is))**2+(z-zg(is))
     $                    **2.le.rayons(is)**2) then
                        test=test+1                       
                        Tabnbs(nbsphere)=is
                        xs(nbsphere)=x
                        ys(nbsphere)=y
                        zs(nbsphere)=z
                        eps0=epscouche(numerocouche(zs(nbsphere),neps
     $                       ,nepsmax,zcouche))
                        if (trope.eq.'iso') then
                           eps=epss(is)
                           call poladiffcomp(aretecube,eps,eps0,k0,dddis
     $                          ,methode,ctmp)  
                           polarisa(nbsphere,1,1)=ctmp
                           polarisa(nbsphere,2,2)=ctmp
                           polarisa(nbsphere,3,3)=ctmp
                           epsilon(nbsphere,1,1)=eps
                           epsilon(nbsphere,2,2)=eps
                           epsilon(nbsphere,3,3)=eps
                        else
                           do ii=1,3
                              do jj=1,3
                                 epsani(ii,jj)=epsanis(is,ii,jj)
                                 epsilon(nbsphere,ii,jj)=epsani(ii,jj)
                              enddo
                           enddo
                           call polaepstenscomp(aretecube,epsani,eps0,k0
     $                          ,dddis,methode,inv,polaeps)
                           do ii=1,3
                              do jj=1,3
                                 polarisa(nbsphere,ii,jj)=polaeps(ii,jj)
                              enddo
                           enddo
                        endif
                        write(10,*) xs(nbsphere)
                        write(11,*) ys(nbsphere)
                        write(12,*) zs(nbsphere)
                     endif
                  enddo
                  if (test.eq.0) then
                     xs(nbsphere)=x
                     ys(nbsphere)=y
                     zs(nbsphere)=z
                     eps0=epscouche(numerocouche(zs(nbsphere),neps
     $                    ,nepsmax,zcouche))
                     epsilon(nbsphere,1,1)=eps0
                     epsilon(nbsphere,2,2)=eps0
                     epsilon(nbsphere,3,3)=eps0   
                     write(10,*) xs(nbsphere)
                     write(11,*) ys(nbsphere)
                     write(12,*) zs(nbsphere) 
                  elseif (test.eq.2) then
                     infostr='sphere are not distincts'
                     nstop=1
                     return
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
