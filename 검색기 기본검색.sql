/* 1.  �ذ� �˻� �µ�  :: ���Ⱓ ������ �ϴ��� �ְ�µ� 20�� */ 
SELECT * FROM (
                    SELECT TO_CHAR(T.tm,'YYYYMMDD')|| ' ' ||TO_CHAR(T.TA_MAX_TM ,'0000')      AS �����ð�   
                     ,S. STN_KO , S.STN_ID
                     , TA_MAX AS   ���
                    , ROW_NUMBER() OVER (PARTITION BY T.STN_ID ORDER BY TA_MAX desc) TNRW
                    FROM  SFC_DAY_TA T
                    ,  ( SELECT * FROM (
                                                                SELECT S.* 
                                                                ,ROW_NUMBER()  OVER (PARTITION BY STN_ID  ORDER BY TM_ED DESC  ) rnk
                                                                FROM STN_AWS S    
                                                            ) WHERE RNK = 1 ) S
                    WHERE   1=1   /* TO_CHAR(T.TM,'MMDD') = '1028' ��������*/
                    AND  T.STN_ID = S.STN_ID
                     /* AND    TA_MAX   >= 30     /*�ְ�µ� ���� ����*/
                    AND   TA_MAX IS NOT NULL   ) M    
            , (SELECT STN_ID , DENSE_RANK()   OVER ( ORDER BY TA_MAX desc) TMRN
         FROM (SELECT TM , STN_ID , TA_MAX, RANK()   OVER ( PARTITION BY STN_ID    ORDER BY TA_MAX desc) TRN  
                    FROM  SFC_DAY_TA  DT WHERE TA_MAX IS NOT NULL   /* AND    TA_MAX   >= 30     /*�ְ�µ� ���� ����*/  )  SDT
          WHERE TRN = 1  ) SDT2 
WHERE  TNRW <=20   /*ǥ�ⰳ�� */  
AND  M.STN_ID = SDT2.STN_ID
ORDER BY TMRN
;

/* 3.  �Ⱓ �˻�  ::  2000-2020 2000�� 1�� 1�Ϻ��� 2020�� 12�� 31�ϱ��� �ϴ��� �ְ�µ� 20��  */ 
SELECT * FROM (
                    SELECT TO_CHAR(T.tm,'YYYYMMDD')|| ' ' ||TO_CHAR(T.TA_MAX_TM ,'0000')      AS �����ð�   
                     ,S. STN_KO , S.STN_ID
                     , TA_MAX AS   ���
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
                     /* AND    TA_MAX   >= 30     /*�ְ�µ� ���� ����*/
                    AND   TO_CHAR(TM,'YYYY') BETWEEN '2000' AND '2020'   /* �Ⱓ���� */
                    --AND  TO_CHAR(TM,'YYYY') <= '2020'          /* �Ⱓ���� */      
                    ) M    
            , (SELECT STN_ID , DENSE_RANK()   OVER ( ORDER BY TA_MAX desc) TMRN
         FROM (SELECT TM , STN_ID , TA_MAX, RANK()   OVER ( PARTITION BY STN_ID    ORDER BY TA_MAX desc) TRN  
                    FROM  SFC_DAY_TA  DT 
                    WHERE TA_MAX IS NOT NULL
                    AND  TO_CHAR(TM,'YYYY') BETWEEN '2000' AND '2020'  /* �Ⱓ���� */      
                    --AND  TO_CHAR(TM,'YYYY')<='2020'  /* �Ⱓ���� */      
                     /* AND    TA_MAX   >= 30     /*�ְ�µ� ���� ����*/
                    )  SDT
          WHERE TRN = 1  ) SDT2 
WHERE  TNRW <=20   /*ǥ�ⰳ�� */  
AND  M.STN_ID = SDT2.STN_ID
ORDER BY TMRN
;


/* 4. ���� �˻�  :: ������ ���Ⱓ ������ �ϴ��� �ְ�µ� 20�� */ 
SELECT * FROM (
SELECT  TO_CHAR(T.tm,'YYYYMMDD')|| ' ' ||TO_CHAR(T.TA_MAX_TM ,'0000')      AS �����ð�   
,S. STN_KO  , S.STN_ID
 , TA_MAX AS   ���
,  ROW_NUMBER()   OVER ( ORDER BY TA_MAX desc) TNRW
FROM  SFC_DAY_TA T
,  ( SELECT * FROM (
                                            SELECT S.* 
                                            ,ROW_NUMBER()  OVER (PARTITION BY STN_ID  ORDER BY TM_ED DESC  ) rnk
                                            FROM STN_AWS S   
                                            WHERE   S.STN_KO ='������'
                                        ) WHERE RNK = 1 ) S
WHERE 1=1
AND  T.STN_ID = S.STN_ID
AND   TA_MAX IS NOT NULL
 /* AND    TA_MAX   >= 30     /*�ְ�µ� ���� ����*/
)
WHERE TNRW <=20
ORDER BY TNRW
;








/* 5.  ���� �˻�    ������  :: ���Ⱓ ������ ������ �ְ�µ� 20�� */ 
select * from (
    SELECT r.* 
   , ROW_NUMBER() OVER (PARTITION BY STN_ID  ORDER BY TA_MAX  desc ) stnrw
    FROM 
    (
            SELECT TO_CHAR(T.tm,'YYYYMMDD')|| ' ' ||TO_CHAR(T.TA_MAX_TM ,'0000')      AS �����ð�   
            ,  TO_CHAR(T.tm,'YYYYMM')  ������
             ,S. STN_KO , S.STN_ID
             , TA_MAX 
            , DENSE_RANK() OVER (PARTITION BY T.STN_ID   ,  TO_CHAR(T.tm,'YYYYMM') ORDER BY TA_MAX  desc) TNRW
            
            FROM  SFC_DAY_TA  T
            ,  ( SELECT * FROM (
                                                        SELECT S.* 
                                                        ,ROW_NUMBER()  OVER (PARTITION BY STN_ID  ORDER BY TM_ED DESC  ) rnk
                                                        FROM STN_AWS S    
                                                    ) WHERE RNK = 1 ) S
            WHERE TO_CHAR(T.TM,'MM') = '11'  /*����*/
            AND  T.STN_ID = S.STN_ID            
             /* AND    TA_MAX   >= 30     /*�ְ�µ� ���� ����*/
            AND   TA_MAX  IS NOT NULL
            ) r
        WHERE TNRW =1       
) M             , (SELECT STN_ID , DENSE_RANK()   OVER ( ORDER BY TA_MAX desc) TMRN
         FROM (SELECT TM , STN_ID , TA_MAX, RANK()   OVER ( PARTITION BY STN_ID     ,  TO_CHAR(tm,'MM') ORDER BY TA_MAX desc) TRN  
                    FROM  SFC_DAY_TA  DT 
                    WHERE TA_MAX IS NOT NULL 
                    AND TO_CHAR(TM,'MM') = '11' /*������� �⺻*/
                     /* AND    TA_MAX   >= 30     /*�ְ�µ� ���� ����*/)  SDT
          WHERE TRN = 1  ) SDT2 
where stnrw <= 20  /*ǥ�ⰳ�� */
AND  M.STN_ID = SDT2.STN_ID
;



/* 11. ���� �˻�  �ϴ��� �ְ�µ� 1��(����) - �׽�Ʈ db�� ���Ͽµ��� �����Ƿ�  20201028 */ 
SELECT * FROM (
SELECT  TO_CHAR(T.tm,'YYYYMMDD')|| ' ' ||TO_CHAR(T.TA_MAX_TM ,'0000')      AS �����ð�   
,S. STN_KO  , S.STN_ID
 , TA_MAX AS   ���
,  DENSE_RANK()   OVER ( ORDER BY TA_MAX desc) TNRW
FROM  SFC_DAY_TA T
,  ( SELECT * FROM (
                                            SELECT S.* 
                                            ,ROW_NUMBER()  OVER (PARTITION BY STN_ID  ORDER BY TM_ED DESC  ) rnk
                                            FROM STN_AWS S    
                                        ) WHERE RNK = 1 ) S
WHERE TO_CHAR(T.TM,'YYYYMMDD') = '20201028'   /*�����Է�*/
AND  T.STN_ID = S.STN_ID
AND   TA_MAX IS NOT NULL
 /* AND    TA_MAX   >= 30     /*�ְ�µ� ���� ����*/
)
WHERE TNRW = 1    /* �Ѱ�*/
--AND       TNRW<=20  /* �ְ�µ����� */

ORDER BY TNRW
;



