package com.songaw.mybatis3plugins;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


import freemarker.template.*;
import org.mybatis.generator.api.GeneratedJavaFile;
import org.mybatis.generator.api.IntrospectedTable;
import org.mybatis.generator.api.PluginAdapter;


import freemarker.core.ParseException;

/**
 * TODO
 *
 * @author songaw
 * @date 2018/8/6 10:09
 */

public class ServiceControllerPlugin extends PluginAdapter {


    public boolean validate(List<String> warnings) {
        return true;
    }


    @Override
    public List<GeneratedJavaFile> contextGenerateAdditionalJavaFiles(IntrospectedTable introspectedTable) {
        //mapper生成地址
        String targetMapperPackage = getProperties().getProperty("targetMapperPackage");
        //实体类包地址
        String targetModelPackage = getProperties().getProperty("targetModelPackage");
        //service生成地址
        String targetServicePackage = getProperties().getProperty("targetServicePackage");
        //controller生成地址
        String targetControllerPackage = getProperties().getProperty("targetControllerPackage");
        //输入参数VO
        String targetPojoVoPackage = getProperties().getProperty("targetPojoVoPackage");
        //返回dto
        String targetPojoDtoPackage = getProperties().getProperty("targetPojoDtoPackage");
        //ID的类型
        String idType = getProperties().getProperty("idType");
        String javaRepositoryPackage = this.getContext().getJavaClientGeneratorConfiguration().getTargetPackage();
        String javaMapperType = introspectedTable.getMyBatis3JavaMapperType();

        //包名
        String topPackage = javaRepositoryPackage.substring(0, javaRepositoryPackage.lastIndexOf('.'));
        //类名
        String javaClassName = javaMapperType.substring(javaMapperType.lastIndexOf('.') + 1, javaMapperType.length()).replace("Mapper", "");
        //生成地址
        String targetProject = this.getContext().getJavaClientGeneratorConfiguration().getTargetProject();


        Map<String, String> root = new HashMap<String, String>();
        root.put("topPackage", topPackage);
        root.put("EntityName", javaClassName);
        root.put("entityName", new StringBuilder().append(Character.toLowerCase(javaClassName.charAt(0)))
                .append(javaClassName.substring(1)).toString());
        root.put("targetMapperPackage", targetMapperPackage);
        root.put("targetModelPackage", targetModelPackage);
        root.put("targetServicePackage", targetServicePackage);
        root.put("targetControllerPackage", targetControllerPackage);
        root.put("targetPojoVoPackage", targetPojoVoPackage);
        root.put("targetPojoDtoPackage", targetPojoDtoPackage);
        root.put("idType", idType);
        //1 类名 2.service的包名 3.主键的类型 4.
        if(targetServicePackage!=null&&targetServicePackage.length()>0) {
            genService(targetProject, targetServicePackage, javaClassName, root);
            System.out.println(targetControllerPackage);
            if(targetControllerPackage!=null&&targetControllerPackage.length()>0){
                genVo(targetProject, targetPojoVoPackage, javaClassName, root);
                genDto(targetProject, targetPojoDtoPackage, javaClassName, root);
                genController(targetProject, targetControllerPackage, javaClassName, root);
            }
        }else{
            System.out.println("service生成地址不能为空");
        }

     //   genController(targetProject, topPackage, javaClassName, root);


        return null;
    }
    @SuppressWarnings("deprecation")
    private void genVo(String targetProject, String targetPojoVoPackage, String javaClassName, Map<String, String> root) {
        String addVoDirPath = targetProject + "/" + targetPojoVoPackage.replaceAll("\\.", "/") ;
        String addVoFilePath = targetProject + "/" + targetPojoVoPackage.replaceAll("\\.", "/")+"/"  +"Add"+javaClassName
                + "Vo.java";
        proccessFtl(addVoDirPath,addVoFilePath,root,"BaseAddVo.ftl");

        String updateVoDirPath = targetProject + "/" + targetPojoVoPackage.replaceAll("\\.", "/") ;
        String updateVoFilePath = targetProject + "/" + targetPojoVoPackage.replaceAll("\\.", "/")+"/"  +"Update"+javaClassName
                + "Vo.java";
        proccessFtl(updateVoDirPath,updateVoFilePath,root,"BaseUpdateVo.ftl");
        String searchVoDirPath = targetProject + "/" + targetPojoVoPackage.replaceAll("\\.", "/") ;
        String searchVoFilePath = targetProject + "/" + targetPojoVoPackage.replaceAll("\\.", "/") +"/" +"Search"+javaClassName
                + "Vo.java";
        proccessFtl(searchVoDirPath,searchVoFilePath,root,"BaseSearchVo.ftl");
    }
    @SuppressWarnings("deprecation")
    private void genDto(String targetProject, String targetPojoDtoPackage, String javaClassName, Map<String, String> root) {
        String dtoDirPath = targetProject + "/" + targetPojoDtoPackage.replaceAll("\\.", "/") ;
        String dtoFilePath = targetProject + "/" + targetPojoDtoPackage.replaceAll("\\.", "/")+"/"  +javaClassName
                + "Dto.java";
        proccessFtl(dtoDirPath,dtoFilePath,root,"BaseDto.ftl");


    }



    @SuppressWarnings("deprecation")
    private void genController(String targetProject, String targetControllerPackage, String javaClassName, Map<String, String> root) {



        String dirPath = targetProject + "/" + targetControllerPackage.replaceAll("\\.", "/") ;
        String filePath = targetProject + "/" + targetControllerPackage.replaceAll("\\.", "/")+"/"  +javaClassName
                + "Controller.java";

        proccessFtl(dirPath,filePath,root,"BaseController.ftl");
    }

    @SuppressWarnings("deprecation")
    private void genService(String targetProject, String targetServicePackage, String javaClassName, Map<String, String> root) {
        String dirPath = targetProject + "/" + targetServicePackage.replaceAll("\\.", "/") ;
        String filePath = targetProject + "/" + targetServicePackage.replaceAll("\\.", "/")+"/" +javaClassName
                + "Service.java";

        String dirPathImpl = targetProject + "/" + targetServicePackage.replaceAll("\\.", "/") + "/impl/" ;
        String filePathImpl = targetProject + "/" + targetServicePackage.replaceAll("\\.", "/") + "/impl/" + javaClassName
                + "ServiceImpl.java";
        System.out.println(filePathImpl);
        System.out.println(filePath);
        proccessFtl(dirPath,filePath,root,"BaseService.ftl");
        proccessFtl(dirPathImpl,filePathImpl,root,"BaseServiceImpl.ftl");

    }
    private void proccessFtl(String dirPath,String filePath, Map<String, String> root,String template){
        File dir = new File(dirPath);
        File file = new File(filePath);
        System.out.println("create"+filePath);
        if (file.exists()) {
            file.delete();
            System.err.println(file + " already exists, it was skipped.");
            try {
                dir.mkdirs();
                file.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        } else {
            try {
                dir.mkdirs();
                file.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        Configuration cfg = new Configuration();
        cfg.setClassForTemplateLoading(this.getClass(), "/");
        cfg.setObjectWrapper(new DefaultObjectWrapper());
        try {
            Template temp = cfg.getTemplate(template);
            Writer out = new OutputStreamWriter(new FileOutputStream(file));
            temp.process(root, out);
            out.flush();
        } catch (TemplateNotFoundException e) {
            e.printStackTrace();
        } catch (MalformedTemplateNameException e) {
            e.printStackTrace();
        } catch (ParseException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (TemplateException e) {
            e.printStackTrace();
        }
    }




}
