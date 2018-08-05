      subroutine inversemat33(mat)
      implicit none
      integer i,j
      double complex mat(3,3),mattmp(3,3),det
      
      det=mat(1,1)*(mat(2,2)*mat(3,3)-mat(2,3)*mat(3,2))-mat(1,2)*(mat(2
     $     ,1)*mat(3,3)-mat(2,3)*mat(3,1))+mat(1,3)*(mat(2,1)*mat(3,2)
     $     -mat(2,2)*mat(3,1))
c$$$      ctmp=0.d0
c$$$      do i=1,3
c$$$         do j=1,3
c$$$            ctmp=mat(i,j)+ctmp
c$$$         enddo
c$$$      enddo

      if (cdabs(det).eq.0.d0) then
         write(*,*) 'stop the inverse of the matrix det=0'
         stop
      endif
      mattmp(1,1)=mat(2,2)*mat(3,3)-mat(2,3)*mat(3,2)
      mattmp(1,2)=mat(1,3)*mat(3,2)-mat(3,3)*mat(1,2)
      mattmp(1,3)=mat(1,2)*mat(2,3)-mat(2,2)*mat(1,3)
      mattmp(2,1)=mat(2,3)*mat(3,1)-mat(3,3)*mat(2,1)
      mattmp(2,2)=mat(1,1)*mat(3,3)-mat(3,1)*mat(1,3)
      mattmp(2,3)=mat(1,3)*mat(2,1)-mat(2,3)*mat(1,1)
      mattmp(3,1)=mat(2,1)*mat(3,2)-mat(3,1)*mat(2,2)
      mattmp(3,2)=mat(1,2)*mat(3,1)-mat(1,1)*mat(3,2)
      mattmp(3,3)=mat(1,1)*mat(2,2)-mat(1,2)*mat(2,1)
      do i=1,3
         do j=1,3
            mat(i,j)=mattmp(i,j)/det
         enddo
      enddo

      end
