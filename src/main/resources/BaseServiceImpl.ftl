package ${targetServicePackage}.impl;

import ${projectPackage}.common.service.impl.BaseServiceImpl;
import ${targetModelPackage}.${EntityName};
import  ${targetServicePackage}.${EntityName}Service;
import ${targetMapperPackage}.${EntityName}Mapper;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.io.Serializable;

/**
* TODO
*
* @author ${author}
* @date ${date}
*/
@Data
@Service
public class ${EntityName}ServiceImpl extends BaseServiceImpl<${EntityName},${idType}> implements ${EntityName}Service  {

    @Autowired
    ${EntityName}Mapper baseMapper;

}