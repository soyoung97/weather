/* 1.  극값 검색 온도  :: 전기간 전지점 일단위 최고온도 20개 */ 
SELECT * FROM (
                    SELECT TO_CHAR(T.tm,'YYYYMMDD')|| ' ' ||TO_CHAR(T.TA_MAX_TM ,'0000')      AS 관측시각   
                     ,S. STN_KO , S.STN_ID
                     , TA_MAX AS   기온
                    , ROW_NUMBER() OVER (PARTITION BY T.STN_ID ORDER BY TA_MAX desc) TNRW
                    FROM  SFC_DAY_TA T
                    ,  ( SELECT * FROM (
                                                                SELECT S.* 
                                                                ,ROW_NUMBER()  OVER (PARTITION BY STN_ID  ORDER BY TM_ED DESC  ) rnk
                                                                FROM STN_AWS S    
                                                            ) WHERE RNK = 1 ) S
                    WHERE   1=1   /* TO_CHAR(T.TM,'MMDD') = '1028' 일자지정*/
                    AND  T.STN_ID = S.STN_ID
                     /* AND    TA_MAX   >= 30     /*최고온도 조건 지정*/
                    AND   TA_MAX IS NOT NULL   ) M    
            , (SELECT STN_ID , DENSE_RANK()   OVER ( ORDER BY TA_MAX desc) TMRN
         FROM (SELECT TM , STN_ID , TA_MAX, RANK()   OVER ( PARTITION BY STN_ID    ORDER BY TA_MAX desc) TRN  
                    FROM  SFC_DAY_TA  DT WHERE TA_MAX IS NOT NULL   /* AND    TA_MAX   >= 30     /*최고온도 조건 지정*/  )  SDT
          WHERE TRN = 1  ) SDT2 
WHERE  TNRW <=20   /*표출개수 */  
AND  M.STN_ID = SDT2.STN_ID
ORDER BY TMRN
;

/* 3.  기간 검색  ::  2000-2020 2000년 1월 1일부터 2020년 12월 31일까지 일단위 최고온도 20개  */ 
SELECT * FROM (
                    SELECT TO_CHAR(T.tm,'YYYYMMDD')|| ' ' ||TO_CHAR(T.TA_MAX_TM ,'0000')      AS 관측시각   
                     ,S. STN_KO , S.STN_ID
                     , TA_MAX AS   기온
                    , ROW_NUMBER() OVER (PARTITION BY T.STN_ID ORDER BY TA_MAX desc) TNRW
                    FROM  SFC_DAY_TA T
                    ,  ( SELECT * FROM (
                                                                SELECT S.* 
                                                                ,ROW_NUMBER()  OVER (PARTITION BY STN_ID  ORDER BY TM_ED DESC  ) rnk
                                                                FROM STN_AWS S    
                                                            ) WHERE RNK = 1 ) S
                    WHERE 1=1
                    AND  T.STN_ID = S.STN_ID
                    AND   TA_MAX IS NOT NULL  
                     /* AND    TA_MAX   >= 30     /*최고온도 조건 지정*/
                    AND   TO_CHAR(TM,'YYYY') BETWEEN '2000' AND '2020'   /* 기간지정 */
                    --AND  TO_CHAR(TM,'YYYY') <= '2020'          /* 기간지정 */      
                    ) M    
            , (SELECT STN_ID , DENSE_RANK()   OVER ( ORDER BY TA_MAX desc) TMRN
         FROM (SELECT TM , STN_ID , TA_MAX, RANK()   OVER ( PARTITION BY STN_ID    ORDER BY TA_MAX desc) TRN  
                    FROM  SFC_DAY_TA  DT 
                    WHERE TA_MAX IS NOT NULL
                    AND  TO_CHAR(TM,'YYYY') BETWEEN '2000' AND '2020'  /* 기간지정 */      
                    --AND  TO_CHAR(TM,'YYYY')<='2020'  /* 기간지정 */      
                     /* AND    TA_MAX   >= 30     /*최고온도 조건 지정*/
                    )  SDT
          WHERE TRN = 1  ) SDT2 
WHERE  TNRW <=20   /*표출개수 */  
AND  M.STN_ID = SDT2.STN_ID
ORDER BY TMRN
;


/* 4. 지점 검색  :: 서귀포 전기간 서귀포 일단위 최고온도 20개 */ 
SELECT * FROM (
SELECT  TO_CHAR(T.tm,'YYYYMMDD')|| ' ' ||TO_CHAR(T.TA_MAX_TM ,'0000')      AS 관측시각   
,S. STN_KO  , S.STN_ID
 , TA_MAX AS   기온
,  ROW_NUMBER()   OVER ( ORDER BY TA_MAX desc) TNRW
FROM  SFC_DAY_TA T
,  ( SELECT * FROM (
                                            SELECT S.* 
                                            ,ROW_NUMBER()  OVER (PARTITION BY STN_ID  ORDER BY TM_ED DESC  ) rnk
                                            FROM STN_AWS S   
                                            WHERE   S.STN_KO ='서귀포'
                                        ) WHERE RNK = 1 ) S
WHERE 1=1
AND  T.STN_ID = S.STN_ID
AND   TA_MAX IS NOT NULL
 /* AND    TA_MAX   >= 30     /*최고온도 조건 지정*/
)
WHERE TNRW <=20
ORDER BY TNRW
;








/* 5.  단위 검색    월단위  :: 전기간 전지점 월단위 최고온도 20개 */ 
select * from (
    SELECT r.* 
   , ROW_NUMBER() OVER (PARTITION BY STN_ID  ORDER BY TA_MAX  desc ) stnrw
    FROM 
    (
            SELECT TO_CHAR(T.tm,'YYYYMMDD')|| ' ' ||TO_CHAR(T.TA_MAX_TM ,'0000')      AS 관측시각   
            ,  TO_CHAR(T.tm,'YYYYMM')  관측월
             ,S. STN_KO , S.STN_ID
             , TA_MAX 
            , DENSE_RANK() OVER (PARTITION BY T.STN_ID   ,  TO_CHAR(T.tm,'YYYYMM') ORDER BY TA_MAX  desc) TNRW
            
            FROM  SFC_DAY_TA  T
            ,  ( SELECT * FROM (
                                                        SELECT S.* 
                                                        ,ROW_NUMBER()  OVER (PARTITION BY STN_ID  ORDER BY TM_ED DESC  ) rnk
                                                        FROM STN_AWS S    
                                                    ) WHERE RNK = 1 ) S
            WHERE TO_CHAR(T.TM,'MM') = '11'  /*월별*/
            AND  T.STN_ID = S.STN_ID            
             /* AND    TA_MAX   >= 30     /*최고온도 조건 지정*/
            AND   TA_MAX  IS NOT NULL
            ) r
        WHERE TNRW =1       
) M             , (SELECT STN_ID , DENSE_RANK()   OVER ( ORDER BY TA_MAX desc) TMRN
         FROM (SELECT TM , STN_ID , TA_MAX, RANK()   OVER ( PARTITION BY STN_ID     ,  TO_CHAR(tm,'MM') ORDER BY TA_MAX desc) TRN  
                    FROM  SFC_DAY_TA  DT 
                    WHERE TA_MAX IS NOT NULL 
                    AND TO_CHAR(TM,'MM') = '11' /*현재월이 기본*/
                     /* AND    TA_MAX   >= 30     /*최고온도 조건 지정*/)  SDT
          WHERE TRN = 1  ) SDT2 
where stnrw <= 20  /*표출개수 */
AND  M.STN_ID = SDT2.STN_ID
;



/* 11. 당일 검색  일단위 최고온도 1개(당일) - 테스트 db는 당일온도가 없으므로  20201028 */ 
SELECT * FROM (
SELECT  TO_CHAR(T.tm,'YYYYMMDD')|| ' ' ||TO_CHAR(T.TA_MAX_TM ,'0000')      AS 관측시각   
,S. STN_KO  , S.STN_ID
 , TA_MAX AS   기온
,  DENSE_RANK()   OVER ( ORDER BY TA_MAX desc) TNRW
FROM  SFC_DAY_TA T
,  ( SELECT * FROM (
                                            SELECT S.* 
                                            ,ROW_NUMBER()  OVER (PARTITION BY STN_ID  ORDER BY TM_ED DESC  ) rnk
                                            FROM STN_AWS S    
                                        ) WHERE RNK = 1 ) S
WHERE TO_CHAR(T.TM,'YYYYMMDD') = '20201028'   /*당일입력*/
AND  T.STN_ID = S.STN_ID
AND   TA_MAX IS NOT NULL
 /* AND    TA_MAX   >= 30     /*최고온도 조건 지정*/
)
WHERE TNRW = 1    /* 한건*/
--AND       TNRW<=20  /* 최고온도개수 */

ORDER BY TNRW
;



