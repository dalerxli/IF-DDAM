      subroutine passagefourierimage(Ex,Ey,Ez,Eimx,Eimy,Eimz,nfft2d
     $     ,nfftmax,imaxk0,deltakx,deltax,planb)
      implicit none
      integer nfft2d,nfft2d2,nfftmax,i,j,kk,indicex,indicey,indeicez
     $     ,indice,imaxk0
      double precision fac,deltakx,deltaky,deltax,pi
      double complex Ex(nfftmax*nfftmax),Ey(nfftmax*nfftmax),Ez(nfftmax
     $     *nfftmax),Eimx(nfftmax*nfftmax),Eimy(nfftmax*nfftmax)
     $     ,Eimz(nfftmax*nfftmax),tmpx,tmpy ,tmpz
      integer FFTW_BACKWARD
      integer*8 planb
      FFTW_BACKWARD=+1
      pi=dacos(-1.d0)
      
   
      deltaky=deltakx
      deltax=2.d0*pi/dble(nfft2d)/deltakx
      fac=deltakx*deltaky

      nfft2d2=nfft2d/2
      write(*,*) 'deltakc',fac,nfft2d,nfftmax,deltakx,deltax,nfft2d2
!$OMP PARALLEL DEFAULT(SHARED) PRIVATE(i)   
!$OMP DO SCHEDULE(STATIC)        
      do i=1,nfftmax*nfftmax
         Eimx(i)=0.d0
         Eimy(i)=0.d0
         Eimz(i)=0.d0
      enddo
!$OMP ENDDO 
!$OMP END PARALLEL

!$OMP PARALLEL DEFAULT(SHARED) PRIVATE(i,j,indicex,indicey,indice,kk)   
!$OMP DO SCHEDULE(STATIC) COLLAPSE(2)           
c      do i=-nfft2d2,nfft2d2-1
      do i=-imaxk0,imaxk0
c         do j=-nfft2d2,nfft2d2-1
         do j=-imaxk0,imaxk0
            if (i.ge.0) then
               indicex=i+1
            else
               indicex=nfft2d+i+1
            endif
            if (j.ge.0) then
               indicey=j+1
            else
               indicey=nfft2d+j+1
            endif
            indice=indicex+nfft2d*(indicey-1)
            kk=i+nfft2d2+1+nfft2d*(j+nfft2d2)
            Eimx(indice)=Ex(kk)
            Eimy(indice)=Ey(kk)
            Eimz(indice)=Ez(kk)    
         enddo
      enddo
!$OMP ENDDO 
!$OMP END PARALLEL

      call dfftw_execute_dft(planb,Eimx,Eimx)
      call dfftw_execute_dft(planb,Eimy,Eimy)
      call dfftw_execute_dft(planb,Eimz,Eimz)

!$OMP PARALLEL DEFAULT(SHARED) PRIVATE(i,j,indicex,indicey,indice,kk)   
!$OMP& PRIVATE(tmpx,tmpy,tmpz)
!$OMP DO SCHEDULE(STATIC) COLLAPSE(2)     
      do i=-nfft2d2,nfft2d2-1
         do j=-nfft2d2,-1

            if (i.ge.0) then
               indicex=i+1
            else
               indicex=nfft2d+i+1
            endif
            if (j.ge.0) then
               indicey=j+1
            else
               indicey=nfft2d+j+1
            endif

            indice=indicex+nfft2d*(indicey-1)
            kk=i+nfft2d2+1+nfft2d*(j+nfft2d2)
            
            tmpx=Eimx(kk)*fac
            tmpy=Eimy(kk)*fac
            tmpz=Eimz(kk)*fac
            Eimx(kk)=Eimx(indice)*fac
            Eimy(kk)=Eimy(indice)*fac
            Eimz(kk)=Eimz(indice)*fac
            Eimx(indice)=tmpx
            Eimy(indice)=tmpy
            Eimz(indice)=tmpz
         enddo
      enddo
!$OMP ENDDO 
!$OMP END PARALLEL
      end