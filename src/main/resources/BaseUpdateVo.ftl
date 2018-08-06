package ${targetPojoVoPackage};

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
* TODO
*
* @author
* @date
*/
@ApiModel(value = "Update${EntityName}Vo")
@Data
public class Update${EntityName}Vo {
    /**
    * id
    */
    @ApiModelProperty(value = "${EntityName}id")
    private ${idType} id;
}
