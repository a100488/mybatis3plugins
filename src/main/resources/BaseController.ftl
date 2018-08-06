package ${targetControllerPackage};

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.guige.fss.common.pojo.dto.PageInfoDto;
import com.guige.fss.common.pojo.dto.Result;
import ${targetModelPackage}.${EntityName};
import ${targetPojoDtoPackage}.${EntityName}Dto;
import ${targetPojoVoPackage}.Add${EntityName}Vo;
import ${targetPojoVoPackage}.Search${EntityName}Vo;
import ${targetPojoVoPackage}.Update${EntityName}Vo;
import ${targetServicePackage}.${EntityName}Service;
import io.swagger.annotations.*;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.util.CollectionUtils;
import org.springframework.util.DigestUtils;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
* TODO
*
* @author
* @date
*/
@Api(value = "${EntityName}接口", tags = { "${EntityName}接口" })
@RestController
@RequestMapping("/v1/${entityName}s")
public class ${EntityName}Controller {
@Autowired
${EntityName}Service ${entityName}Service;


    /**
    * 添加
    * @param vo
    */
    @ApiOperation(value = "添加${EntityName}", notes = "添加${entityName}")
    @ApiImplicitParam(name = "vo", value = "add${EntityName}Vo", required = true, dataType = "Add${EntityName}Vo")
    @ApiResponses({ @ApiResponse(code = 400, message = "请求参数错误"), @ApiResponse(code = 404, message = "请求路径没有或页面跳转路径error", response = Result.class) })
    @PostMapping
    public Result<${EntityName}Dto> add${EntityName}(@RequestBody Add${EntityName}Vo vo) {
        ${EntityName} ${entityName} = new ${EntityName}();
        BeanUtils.copyProperties(vo,${entityName});
        ${entityName}Service.insert(${entityName});
        ${EntityName}Dto ${entityName}Dto = new  ${EntityName}Dto();
        BeanUtils.copyProperties(${entityName},${entityName}Dto);
        return Result.getSuccessResult(${entityName}Dto);
    }
    @ApiOperation(value = "修改${EntityName}", notes = "修改${entityName}")
    @ApiImplicitParam(name = "vo", value = "update${EntityName}Vo", required = true, dataType = "Update${EntityName}Vo")
    @ApiResponses({ @ApiResponse(code = 400, message = "请求参数错误"), @ApiResponse(code = 404, message = "请求路径没有或页面跳转路径error", response = Result.class) })
    @PutMapping
    public Result update${EntityName}(@RequestBody Update${EntityName}Vo vo){
        try {

            ${idType} id=vo.getId();
            if(id==null){
                return Result.getSystemErrorResult("传入参数错误");
            }
            ${EntityName} ${entityName} = new ${EntityName}();
            BeanUtils.copyProperties(vo,${entityName});
            ${entityName}Service.update(${entityName});
            return Result.getSuccessResult(null);
        }catch (Exception e){
            return Result.getSystemErrorResult(e.getMessage());
        }
    }
    @ApiOperation(value = "删除 ${EntityName} ", notes = "删除 ${entityName} ")
    @ApiImplicitParam(name = "id", value = "${EntityName}id", required = true, dataType = "String")
    @ApiResponses({ @ApiResponse(code = 400, message = "请求参数错误 "), @ApiResponse(code = 404, message = "请求路径没有或页面跳转路径error   ", response = Result.class) })
    @DeleteMapping(value = "/{id}")
    public Result delete${EntityName}ById(@PathVariable("id") ${idType} id){
        try {
        ${EntityName} ${entityName} =${entityName}Service.selectByPk(id);
            if(${entityName}!=null){
                ${entityName}Service.deleteByPk(id);
            }else{
                return Result.getSystemErrorResult(" 找不到要删除的数 ");
            }

            return Result.getSuccessResult(null);
        }catch (Exception e){
            return Result.getSystemErrorResult(e.getMessage());
        }
    }
    @ApiOperation(value = "删除列表 ${EntityName}s", notes = "删除列表 ${entityName} ")
    @ApiImplicitParam(name = "ids", value = "${entityName}ids:id1,id2,id3", required = true, dataType = "String")
    @ApiResponses({ @ApiResponse(code = 400, message = "请求参数错误 "), @ApiResponse(code = 404, message = "请求路径没有或页面跳转路径error   ", response = Result.class) })
    @DeleteMapping(value = "/deleteUserByIds")
    public Result delete${EntityName}ByIds(@RequestParam("ids") String ids){
        try {
            String [] idstr=ids.split(",");
            List<${idType}> idList = new ArrayList<>();
            for(String id:idstr){
                idList.add(${idType}.parse${idType}(id));
            }
            ${entityName}Service.deleteByPks(idList);
            return Result.getSuccessResult(null);
        }catch (Exception e){
            return Result.getSystemErrorResult(e.getMessage());
        }
    }
    @ApiOperation("根据ID查询信息")
    @GetMapping(value = "/{id}")
    @ApiImplicitParam(name = "id", value = "${EntityName}ID", dataType = "${idType}", paramType = "query")
    @ResponseBody
    public Result<${EntityName}Dto> get${EntityName}ById(@PathVariable("id") ${idType} id) {
        ${EntityName} ${entityName} = ${entityName}Service.selectByPk(id);
        ${EntityName}Dto ${entityName}Dto = new ${EntityName}Dto();
        BeanUtils.copyProperties(${entityName},${entityName}Dto);
        return Result.getSuccessResult(${entityName}Dto);
    }


    @ApiOperation(value = " 分页列表查询 ", notes = " 分页列表查询 ")
        @ApiResponses({ @ApiResponse(code = 400, message = "请求参数错误 "), @ApiResponse(code = 404, message = "请求路径没有或页面跳转路径error   ", response = Result.class) })
    @RequestMapping(path = "/list/search",method = RequestMethod.GET)
    public Result<PageInfoDto> find${EntityName}sPage(@ModelAttribute Search${EntityName}Vo searchVo){
        PageHelper.startPage(searchVo.getPageIndex(),searchVo.getPageSize());
        ${EntityName} search${EntityName} = new ${EntityName}();
        BeanUtils.copyProperties(searchVo,search${EntityName});
        List<${EntityName}>  list=  ${entityName}Service.select(search${EntityName});
        PageInfoDto<${EntityName}> thePage=new PageInfoDto<${EntityName}>(list);
        return Result.getSuccessResult(thePage);
    }
    @ApiOperation(value = "自定义分页search ", notes = "自定义分页search ")
    @ApiResponses({ @ApiResponse(code = 400, message = "请求参数错误 "), @ApiResponse(code = 404, message = "请求路径没有或页面跳转路径error   ", response = Result.class) })
    @RequestMapping(path = "/list/search2",method = RequestMethod.GET)
    public Result<PageInfoDto<${EntityName}Dto>> find${EntityName}sPage2(@ModelAttribute Search${EntityName}Vo searchVo){
        PageHelper.startPage(searchVo.getPageIndex(),searchVo.getPageSize());
        List<${EntityName}Dto>  list=  null;//todo 自己实现  ${entityName}Service.find${EntityName}Dtos(searchVo);
        PageInfoDto<${EntityName}Dto> thePage=new PageInfoDto<${EntityName}Dto>(list);
        return Result.getSuccessResult(thePage);
    }

}
