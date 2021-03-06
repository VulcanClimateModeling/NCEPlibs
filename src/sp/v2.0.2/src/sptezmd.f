C-----------------------------------------------------------------------
      SUBROUTINE SPTEZMD(IROMB,MAXWV,IDRT,IMAX,JMAX,KMAX,
     &                   WAVE,GRIDMN,GRIDX,GRIDY,IDIR)
C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C
C SUBPROGRAM:  SPTEZMD    PERFORM SIMPLE GRADIENT SPHERICAL TRANSFORMS
C   PRGMMR: IREDELL       ORG: W/NMC23       DATE: 96-02-29
C
C ABSTRACT: THIS SUBPROGRAM PERFORMS SPHERICAL TRANSFORMS
C           BETWEEN SPECTRAL COEFFICIENTS OF SCALAR FIELDS
C           AND THEIR MEANS AND GRADIENTS ON A GLOBAL CYLINDRICAL GRID.
C           THE WAVE-SPACE CAN BE EITHER TRIANGULAR OR RHOMBOIDAL.
C           THE GRID-SPACE CAN BE EITHER AN EQUALLY-SPACED GRID
C           (WITH OR WITHOUT POLE POINTS) OR A GAUSSIAN GRID.
C           THE WAVE FIELDS ARE IN SEQUENTIAL 'IBM ORDER'.
C           THE GRID FIELDS ARE INDEXED EAST TO WEST, THEN NORTH TO SOUTH.
C           FOR MORE FLEXIBILITY AND EFFICIENCY, CALL SPTRAN.
C           SUBPROGRAM CAN BE CALLED FROM A MULTIPROCESSING ENVIRONMENT.
C
C PROGRAM HISTORY LOG:
C   96-02-29  IREDELL
C
C USAGE:    CALL SPTEZMD(IROMB,MAXWV,IDRT,IMAX,JMAX,KMAX,
C    &                   WAVE,GRIDMN,GRIDX,GRIDY,IDIR)
C   INPUT ARGUMENTS:
C     IROMB    - INTEGER SPECTRAL DOMAIN SHAPE
C                (0 FOR TRIANGULAR, 1 FOR RHOMBOIDAL)
C     MAXWV    - INTEGER SPECTRAL TRUNCATION
C     IDRT     - INTEGER GRID IDENTIFIER
C                (IDRT=4 FOR GAUSSIAN GRID,
C                 IDRT=0 FOR EQUALLY-SPACED GRID INCLUDING POLES,
C                 IDRT=256 FOR EQUALLY-SPACED GRID EXCLUDING POLES)
C     IMAX     - INTEGER EVEN NUMBER OF LONGITUDES.
C     JMAX     - INTEGER NUMBER OF LATITUDES.
C     WAVE     - REAL (MX,KMAX) WAVE FIELD IF IDIR>0
C                WHERE MX=(MAXWV+1)*((IROMB+1)*MAXWV+2)
C     GRIDMN   - REAL (KMAX) GLOBAL MEAN IF IDIR<0
C     GRIDX    - REAL (IMAX,JMAX,KMAX) GRID X-GRADIENTS (E->W,N->S) IF IDIR<0
C     GRIDY    - REAL (IMAX,JMAX,KMAX) GRID Y-GRADIENTS (E->W,N->S) IF IDIR<0
C     IDIR     - INTEGER TRANSFORM FLAG
C                (IDIR>0 FOR WAVE TO GRID, IDIR<0 FOR GRID TO WAVE)
C   OUTPUT ARGUMENTS:
C     WAVE     - REAL (MX,KMAX) WAVE FIELD IF IDIR<0
C                WHERE MX=(MAXWV+1)*((IROMB+1)*MAXWV+2)
C     GRIDMN   - REAL (KMAX) GLOBAL MEAN IF IDIR>0
C     GRIDX    - REAL (IMAX,JMAX,KMAX) GRID X-GRADIENTS (E->W,N->S) IF IDIR>0
C     GRIDY    - REAL (IMAX,JMAX,KMAX) GRID Y-GRADIENTS (E->W,N->S) IF IDIR>0
C
C SUBPROGRAMS CALLED:
C   SPTRAND      PERFORM A GRADIENT SPHERICAL TRANSFORM
C   NCPUS        GETS ENVIRONMENT NUMBER OF CPUS
C
C REMARKS: MINIMUM GRID DIMENSIONS FOR UNALIASED TRANSFORMS TO SPECTRAL:
C   DIMENSION                    LINEAR              QUADRATIC
C   -----------------------      ---------           -------------
C   IMAX                         2*MAXWV+2           3*MAXWV/2*2+2
C   JMAX (IDRT=4,IROMB=0)        1*MAXWV+1           3*MAXWV/2+1
C   JMAX (IDRT=4,IROMB=1)        2*MAXWV+1           5*MAXWV/2+1
C   JMAX (IDRT=0,IROMB=0)        2*MAXWV+3           3*MAXWV/2*2+3
C   JMAX (IDRT=0,IROMB=1)        4*MAXWV+3           5*MAXWV/2*2+3
C   JMAX (IDRT=256,IROMB=0)      2*MAXWV+1           3*MAXWV/2*2+1
C   JMAX (IDRT=256,IROMB=1)      4*MAXWV+1           5*MAXWV/2*2+1
C   -----------------------      ---------           -------------
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN 77
C
C$$$
      REAL WAVE((MAXWV+1)*((IROMB+1)*MAXWV+2),KMAX)
      REAL GRIDMN(KMAX),GRIDX(IMAX,JMAX,KMAX),GRIDY(IMAX,JMAX,KMAX)
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      JC=NCPUS()
      CALL SPTRAND(IROMB,MAXWV,IDRT,IMAX,JMAX,KMAX,
     &             0,0,0,0,0,0,0,0,JC,
     &             WAVE,GRIDMN,
     &             GRIDX,GRIDX(1,JMAX,1),GRIDY,GRIDY(1,JMAX,1),IDIR)
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      END
