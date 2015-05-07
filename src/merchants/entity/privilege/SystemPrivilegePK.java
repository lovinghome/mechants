package merchants.entity.privilege;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;

/**
 * 
 * 权限主键,要做为主键必须要实现序列化接口
 */
@Embeddable
public class SystemPrivilegePK implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2868586748537847199L;
	/*模块*/
	@Column(length=50)
	private String module;
	/*权限值*/
	@Column(length=50)
	private String privilege;
	
	/*无参数构造函数*/
	public SystemPrivilegePK() {
		
	}
	
	public SystemPrivilegePK(String module, String privilege) {
		super();
		this.module = module;
		this.privilege = privilege;
	}

	public String getModule() {
		return module;
	}
	public void setModule(String module) {
		this.module = module;
	}
	public String getPrivilege() {
		return privilege;
	}
	public void setPrivilege(String privilege) {
		this.privilege = privilege;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((module == null) ? 0 : module.hashCode());
		result = prime * result
				+ ((privilege == null) ? 0 : privilege.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		SystemPrivilegePK other = (SystemPrivilegePK) obj;
		if (module == null) {
			if (other.module != null)
				return false;
		} else if (!module.equals(other.module))
			return false;
		if (privilege == null) {
			if (other.privilege != null)
				return false;
		} else if (!privilege.equals(other.privilege))
			return false;
		return true;
	}
	
	
}
