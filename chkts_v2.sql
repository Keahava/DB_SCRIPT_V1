/* TOTAL, FREE AND USED SPACE IN TABLESPACES */
set feedback off
 SET LINESIZE 115
 COLUMN TABLESPACE FORMAT A15
 COLUMN autoextensible  FORMAT A7
 COLUMN totalspace  FORMAT 9999999
 select t.tablespace,t.status,  t.totalspace as "Totalspace(MB)",
 round((t.totalspace-nvl(fs.freespace,0)),2) as "Used Space(MB)",
 nvl(fs.freespace,0) as "Freespace(MB)",
 round(((t.totalspace-nvl(fs.freespace,0))/t.totalspace)*100,2) as "%Used",
 round((nvl(fs.freespace,0)/t.totalspace)*100,2) as "% Free",t.autoextensible
  from
 (select autoextensible,status,round(sum(d.bytes)/(1024*1024)) as totalspace,d.tablespace_name tablespace
 from dba_data_files d
 group by d.tablespace_name,autoextensible,status) t,
 (select round(sum(f.bytes)/(1024*1024)) as freespace,f.tablespace_name tablespace
 from dba_free_space f
 group by f.tablespace_name) fs
 where t.tablespace=fs.tablespace(+)
 order by t.tablespace ;

set heading off;

 select t.tablespace,t.status,  t.totalspace as "Totalspace(MB)",
 round((t.totalspace-nvl(fs.freespace,0)),2) as "Used Space(MB)",
 nvl(fs.freespace,0) as "Freespace(MB)",
 round(((t.totalspace-nvl(fs.freespace,0))/t.totalspace)*100,2) as "%Used",
 round((nvl(fs.freespace,0)/t.totalspace)*100,2) as "% Free",t.autoextensible
  from
 (select autoextensible,status,round(sum(d.bytes)/(1024*1024)) as totalspace,d.tablespace_name tablespace
 from dba_temp_files d
 group by d.tablespace_name,autoextensible,status) t,
 (select round(sum(f.bytes)/(1024*1024)) as freespace,f.tablespace_name tablespace
 from dba_free_space f
 group by f.tablespace_name) fs
 where t.tablespace=fs.tablespace(+)
 order by t.tablespace;
set feedback on
set heading on
