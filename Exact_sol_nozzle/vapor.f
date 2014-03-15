       program exact
       implicit real*8(a-h,o-z)
       parameter(im=1601,ieq=4)
       dimension xx(im),surf(im)
       open(unit=100,file='exact_vapor_1600.txt',status='unknown')
       data iconvd/1/,inj/0/
c
       gamma=1.34d0
       pinf=0.d0
       cv=1265.d0
       gap=gamma+1.d0
       gam=gamma-1.d0
c
       pb =5.d5
c
       dltube =1.d0
       sentree=1.5d0
       ssortie=1.5d0
       if(iconvd.eq.1) then
        scol   =0.5d0
        dlcol  =0.5d0*dltube
       endif
       dx=dltube/dfloat(im-1)
       do i=1,im
        xx(i)=dfloat(i-1)*dx
       enddo
c
       if(inj.eq.0) then !reservoir (pression et temperature tot.)
        t0=453.d0
        p0=1.d6
        ro0= (p0+pinf)/(gam*cv*t0)
       endif
       if(inj.eq.1) then !injection (debit massique et temperature)
        t=274.d0
        dm=5.d1
        dm=dm*sentree
       endif
c
       if(iconvd.eq.0) then
        print*,'calcul convergent seul donc isentropique'
        do i=1,im
         surf(i)=(ssortie-sentree)/dltube*xx(i)+sentree
        enddo
c
        if(inj.eq.0) then
         print*,'reservoirs a gauche et a droite'
         c0 =dsqrt(gamma*(p0+pinf)/ro0)
         z0 =ro0*c0
         pc =(p0+pinf)*(2.d0/gap)**(gamma/gam)-pinf 
         if(pb.gt.pc) then !ecoulement subsonique partout
          print*,'ecoulement subsonique'
          rap=(pb+pinf)/(p0+pinf)
          dm=z0*ssortie*dsqrt(2.d0/gam*(rap**(2.d0/gamma)
     &                          -rap**(gap/gamma)))
         else !ecoulement sonique en sortie
          print*,'ecoulement sonique en sortie'
          dm =z0*ssortie*(2.d0/gap)**(0.5d0*gap/gam)
         endif
        endif
c
        if(inj.eq.1) then
         print*,'injection a gauche et reservoir a droite'
         rapa=sentree/ssortie
         rapa=rapa*(0.5d0*gap)**(0.5d0*gap/gam)
         dmach=0.5d0
         do k=1,50
          term=(1.d0+0.5d0*gam*dmach*dmach)**(0.5d0*gap/gam)
          f=term-rapa*dmach
          if(dabs(f).lt.1.d-8) goto 151
          df=0.5d0*gap*term/(1.d0+0.5d0*gam*dmach*dmach)*dmach-rapa
          dmach=dmach-f/df
         enddo
         print*,'non-convergence Newton 151'
151      continue
         c  =dsqrt(gamma*gam*cv*t)
         v  =dmach*c
         ro =dm/(v*sentree)
         p  =ro*c*c/gamma-pinf
         t0 =t+0.5d0*v*v/(gamma*cv)
         p0 =(p+pinf)*(t0/t)**(gamma/gam)-pinf
         ro0=(p0+pinf)/(gam*cv*t0)
         c0 =dsqrt(gamma*(p0+pinf)/ro0)
         z0 =ro0*c0
         pc =(p0+pinf)*(2.d0/gap)**(gamma/gam)-pinf
         if(pb.gt.pc) then !ecoulement subsonique partout
          print*,'ecoulement subsonique'
          term=0.5d0*(gam*dm/((pb+pinf)*ssortie))**2*cv*t/gamma
          rapa=ssortie*ssortie/(sentree*sentree)
          rap=1.d0
          do k=1,50
           f=rap-1.d0+term*(rap*rap-rapa*rap**(2.d0*gamma/gam))
           if(dabs(f).lt.1.d-10) goto 152
           df=1.d0+2.d0*term*rap*(1.d0-gamma/gam*rapa*rap**(2.d0/gam))
           rap=rap-f/df
          enddo
          print*,'non-convergence Newton 152'
152       continue
          p=(pb+pinf)/rap**(gamma/gam)-pinf
          c=dsqrt(gamma*gam*cv*t)
          ro=gamma*(p+pinf)/(c*c)
          v=dm/(ro*sentree)
          t0 =t+0.5d0*v*v/(gamma*cv)
          p0 =(p+pinf)*(t0/t)**(gamma/gam)-pinf
          ro0=(p0+pinf)/(gam*cv*t0)
          z0 =ro0*c0
         else !ecoulement sonique en sortie
          print*,'ecoulement sonique en sortie'
         endif
        endif       
c
        term=0.5d0*gam*dm*dm/(z0*z0)
        rap=1.d0
        do i=1,im
         term2=term/(surf(i)*surf(i))
         do k=1,50
          f=rap*rap-rap**gap-term2
          if(dabs(f).lt.1.d-10) goto 153
          df=2.d0*rap-gap*rap**gamma
          rap=rap-f/df
         enddo
         print*,'non-convergence Newton 153'
153      continue
         p  = (p0+pinf)*rap**gamma-pinf
         ro = ro0*rap
         c  = dsqrt(gamma*(p+pinf)/ro)
         t  = (p+pinf)/(gam*cv*ro)
         dmach=dm/(ro*c*surf(i))
         write(100,140) xx(i),ro,c*dmach,p*1.d-5,dmach,t,surf(i)
        enddo
c
       endif
c
       if(iconvd.eq.1) then
        print*,'calcul convergent-divergent'
        
        pi=dacos(-1.d0)
        do i=1,im
          surf(i)=1.d0+0.5d0*dcos(2.d0*pi*xx(i)) !tuyere trigo..
        enddo
        
!        do i=1,im
!         if(xx(i).le.dlcol) then
!          surf(i)=(scol-sentree)/dlcol*xx(i)+sentree
!         else
!          surf(i)=(ssortie-scol)*(xx(i)-dlcol)/(dltube-dlcol)+scol
!         endif
!        enddo
c
        if(inj.eq.0) then
         print*,'reservoirs a gauche et a droite'
        endif
c
        if(inj.eq.1) then
         print*,'injection a gauche et reservoir a droite'
         rapa=sentree/scol
         rapa=rapa*(0.5d0*gap)**(0.5d0*gap/gam)
         dmach=0.5d0
         do k=1,50
          term=(1.d0+0.5d0*gam*dmach*dmach)**(0.5d0*gap/gam)
          f=term-rapa*dmach
          if(dabs(f).lt.1.d-8) goto 155
          df=0.5d0*gap*term/(1.d0+0.5d0*gam*dmach*dmach)*dmach-rapa
          dmach=dmach-f/df
         enddo
         print*,'non-convergence Newton 155'
155      continue
         c  =dsqrt(gamma*gam*cv*t)
         v  =dmach*c
         ro =dm/(v*sentree)
         p  =ro*c*c/gamma-pinf
         t0 =t+0.5d0*v*v/(gamma*cv)
         p0 =(p+pinf)*(t0/t)**(gamma/gam)-pinf
         ro0=(p0+pinf)/(gam*cv*t0)
         c0 =dsqrt(gamma*(p0+pinf)/ro0)
         z0 =ro0*c0
         term2=0.5d0*gam*dm*dm/(z0*z0)/(ssortie*ssortie)
         rap=1.d0
         do k=1,50
          f=rap*rap-rap**gap-term2
          if(dabs(f).lt.1.d-10) goto 156
          df=2.d0*rap-gap*rap**gamma
          rap=rap-f/df
         enddo
         print*,'non-convergence Newton 156'
156      continue
         pc1 =(p0+pinf)*rap**gamma-pinf
         if(pb.gt.pc1) then
          print*,'tuyere non amorcee'
          print*,'tuyere subsonique isentropique'
          term=0.5d0*(gam*dm/((pb+pinf)*ssortie))**2*cv*t/gamma
          rapa=ssortie*ssortie/(sentree*sentree)
          rap=1.d0
          do k=1,50
           f=rap-1.d0+term*(rap*rap-rapa*rap**(2.d0*gamma/gam))
           if(dabs(f).lt.1.d-10) goto 157
           df=1.d0+2.d0*term*rap*(1.d0-gamma/gam*rapa*rap**(2.d0/gam))
           rap=rap-f/df
          enddo
          print*,'non-convergence Newton 157'
157       continue
          p=(pb+pinf)/rap**(gamma/gam)-pinf
          c=dsqrt(gamma*gam*cv*t)
          ro=gamma*(p+pinf)/(c*c)
          v=dm/(ro*sentree)
          t0 =t+0.5d0*v*v/(gamma*cv)
          p0 =(p+pinf)*(t0/t)**(gamma/gam)-pinf
          ro0=(p0+pinf)/(gam*cv*t0)
         endif
        endif
c
        c0  =dsqrt(gamma*(p0+pinf)/ro0)
        z0  =ro0*c0
        dmc =z0*scol*(2.d0/gap)**(0.5d0*gap/gam) 
        term=0.5d0*gam*dmc*dmc/(z0*z0)
        term2=term/(ssortie*ssortie)
        rap=1.d0
        do k=1,50
         f=rap*rap-rap**gap-term2
         if(dabs(f).lt.1.d-10) goto 158
         df=2.d0*rap-gap*rap**gamma
         rap=rap-f/df
        enddo
        print*,'non-convergence Newton 158'
158     continue
        pc1  = (p0+pinf)*rap**gamma-pinf
        dmach1=dsqrt(2.d0/gam*(1.d0/rap**gam-1.d0))
        print*,'rpc1=',rap**gamma,'  Mach1=',dmach1
        rap=0.5d0*(2.d0/gap)**(1.d0/gam)
        do k=1,50
         f=rap*rap-rap**gap-term2
         if(dabs(f).lt.1.d-10) goto 159
         df=2.d0*rap-gap*rap**gamma
         rap=rap-f/df
        enddo
        print*,'non-convergence Newton 159'
159     continue
        pc3  = (p0+pinf)*rap**gamma-pinf
        dmach3=dsqrt(2.d0/gam*(1.d0/rap**gam-1.d0))
        pc2 = (pc3+pinf)*(2.d0*gamma*dmach3*dmach3-gam)/gap-pinf
        print*,'rpc2=',(pc2+pinf)/(p0+pinf)
        print*,'rpc3=',(pc3+pinf)/(p0+pinf),'  Mach3=',dmach3
        print*,'rpc =',(pb+pinf)/(p0+pinf)
c
        if(pb.ge.pc1) then !ecoulement subsonique
         print*,'ecoulement subsonique DV isentropique'
         rap=(pb+pinf)/(p0+pinf)
         dm=z0*ssortie*dsqrt(2.d0/gam*(rap**(2.d0/gamma)
     &                          -rap**(gap/gamma)))
         term=0.5d0*gam*dm*dm/(z0*z0)
         rap=1.d0
         do i=1,im
          term2=term/(surf(i)*surf(i))
          do k=1,50
           f=rap*rap-rap**gap-term2
           if(dabs(f).lt.1.d-10) goto 160
           df=2.d0*rap-gap*rap**gamma
           rap=rap-f/df
          enddo
          print*,'non-convergence Newton 160'
160       continue
          p  = (p0+pinf)*rap**gamma-pinf
          ro = ro0*rap
          c  = dsqrt(gamma*(p+pinf)/ro)
          t  = (p+pinf)/(gam*cv*ro)
          dmach=dm/(ro*c*surf(i))
          write(100,140) xx(i),ro,c*dmach,p*1.d-5,dmach,t,surf(i)
         enddo
        endif
c
        if(pb.lt.pc1.and.pb.gt.pc2) then !ecoulement super-subsonique isentropique
         print*,'ecoulement supersubsonique DV choc'
         dm=dmc
         term=(2.d0/gap)**(gap/gam)*(scol/ssortie*(p0+pinf)
     &         /(pb+pinf))**2.d0
         dms2=(dsqrt(1.d0+2.d0*gam*term)-1.d0)/gam
         p02sp01=(pb+pinf)/(p0+pinf)*(1.d0+0.5d0*gam*dms2)**(gamma/gam)
         p02=p02sp01*(p0+pinf)-pinf
         term3=0.5d0*gap/p02sp01**(gam/gamma)
         dm1=1.d0
         do k=1,50
          term1=1.d0+0.5d0*gam*dm1
          term2=((2.d0*gamma*dm1-gam)/gap)**(1.d0/gamma)
          f=term1*term2-term3*dm1
          if(dabs(f).lt.1.d-10) goto 161
          df=0.5d0*gam*term2+2.d0/gap*term1/term2**gam-term3
          df=dabs(df)
          dm1=dm1-f/df
         enddo
         print*,'non-convergence Newton 161'
161      continue
         dm1=dsqrt(dm1)
         sodc=scol*(2.d0*term1/gap)**(0.5d0*gap/gam)/dm1
         ro2sro1=0.5d0*gap*dm1*dm1/term1
         ro01sro1=term1**(1.d0/gam)
         dm2=term1/(gamma*dm1*dm1-0.5d0*gam)
         ro02sro2=(1.d0+0.5d0*gam*dm2)**(1.d0/gam)
         ro02=ro02sro2*ro2sro1/ro01sro1*ro0
         c02=dsqrt(gamma*(p02+pinf)/ro02)
         z02=ro02*c02
c
         do i=1,im
          if(xx(i).le.dlcol) then
           term=0.5d0*gam*dm*dm/(z0*z0)
           term2=term/(surf(i)*surf(i))
           rap=1.d0
           do k=1,50
            f=rap*rap-rap**gap-term2
            if(dabs(f).lt.1.d-10) goto 162
            df=2.d0*rap-gap*rap**gamma
            rap=rap-f/df
           enddo
           print*,'non-convergence Newton 162'
162        continue
           p  = (p0+pinf)*rap**gamma-pinf
           ro = ro0*rap
          else
           if(surf(i).le.sodc) then
            term=0.5d0*gam*dm*dm/(z0*z0)
            term2=term/(surf(i)*surf(i))
            rap=0.5d0*(2.d0/gap)**(1.d0/gam)
            do k=1,50
             f=rap*rap-rap**gap-term2
             if(dabs(f).lt.1.d-10) goto 163
             df=2.d0*rap-gap*rap**gamma
             rap=rap-f/df
            enddo
            print*,'non-convergence Newton 163'
163         continue
            p  = (p0+pinf)*rap**gamma-pinf
            ro = ro0*rap
           else
            term=0.5d0*gam*dm*dm/(z02*z02)
            term2=term/(surf(i)*surf(i))
            rap=1.d0
            do k=1,50
             f=rap*rap-rap**gap-term2
             if(dabs(f).lt.1.d-10) goto 164
             df=2.d0*rap-gap*rap**gamma
             rap=rap-f/df
            enddo
            print*,'non-convergence Newton 164'
164         continue
            p  = (p02+pinf)*rap**gamma-pinf
            ro = ro02*rap
           endif
          endif
          c  = dsqrt(gamma*(p+pinf)/ro)
          t  = (p+pinf)/(gam*cv*ro)
          dmach=dm/(ro*c*surf(i))
          write(100,140) xx(i),ro,c*dmach,p*1.d-5,dmach,t,surf(i)
         enddo
        endif
c
        if(pb.le.pc2) then !ecoulement supersonique isentropique
         print*,'ecoulement supersonique DV isentropique'
         dm=dmc
         term=0.5d0*gam*dm*dm/(z0*z0)
         do i=1,im
          term2=term/(surf(i)*surf(i))
          if(xx(i).le.dlcol) then
           rap=1.d0
          else
           rap=0.5d0*(2.d0/gap)**(1.d0/gam)
          endif
          do k=1,50
           f=rap*rap-rap**gap-term2
           if(dabs(f).lt.1.d-10) goto 165
           df=2.d0*rap-gap*rap**gamma
           rap=rap-f/df
          enddo
          print*,'non-convergence Newton 165'
165       continue
          p  = (p0+pinf)*rap**gamma-pinf
          ro = ro0*rap
          c  = dsqrt(gamma*(p+pinf)/ro)
          t  = (p+pinf)/(gam*cv*ro)
          dmach=dm/(ro*c*surf(i))
          write(100,140) xx(i),ro,c*dmach,p*1.d-5,dmach,t,surf(i)
         enddo
        endif
       endif
140    format(7(e16.8,1x))
       close(100)
       stop
       end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c                           fin du programme
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
