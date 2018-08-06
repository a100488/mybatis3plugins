package ${targetPojoDtoPackage};

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.io.Serializable;
/**
* TODO
*
* @author ${author}
* @date ${date}
*/
@ApiModel(value = "${EntityName}Dto")
@Data
public class ${EntityName}Dto  implements Serializable {
    private static final long serialVersionUID = 1L;
}
