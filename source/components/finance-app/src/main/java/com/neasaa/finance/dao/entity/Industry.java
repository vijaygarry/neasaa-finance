package com.neasaa.finance.dao.entity;

import com.neasaa.base.app.entity.BaseEntity;
import java.io.Serial;
import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Industry extends BaseEntity {

  @Serial private static final long serialVersionUID = 1745893230061L;
  private String industry;
  private String description;
  private boolean enable;
  private int createdBy;
  private Date createdDate;
  private int lastUpdatedBy;
  private Date lastUpdatedDate;
}
