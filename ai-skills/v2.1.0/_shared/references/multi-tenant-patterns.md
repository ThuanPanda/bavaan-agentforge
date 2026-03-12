# Multi-Tenant Patterns Reference
## Bavaan NestJS + Prisma Stack

---

## 1. Prisma Schema Pattern

```prisma
model Tenant {
  id        String   @id @default(uuid()) @db.Uuid
  name      String
  createdAt DateTime @default(now())

  // All tenant-scoped models reference this
  projects  Project[]
  users     User[]
}

model Project {
  id        String   @id @default(uuid()) @db.Uuid
  tenantId  String   @db.Uuid         // ← REQUIRED on every model
  name      String
  createdAt DateTime @default(now())

  tenant    Tenant   @relation(fields: [tenantId], references: [id], onDelete: Cascade)

  @@index([tenantId])                  // ← REQUIRED for performance
  @@unique([id, tenantId])             // ← ensures uniqueness per tenant
}
```

---

## 2. NestJS Service Pattern

```typescript
@Injectable()
export class ProjectService {
  constructor(private readonly prisma: PrismaService) {}

  // ✅ findMany — always scope by tenantId
  async findAll(tenantId: string): Promise<Project[]> {
    return this.prisma.project.findMany({
      where: { tenantId },
      orderBy: { createdAt: 'desc' },
    });
  }

  // ✅ findOne — fetch then verify ownership
  async findOne(id: string, tenantId: string): Promise<Project> {
    const project = await this.prisma.project.findUnique({ where: { id } });
    if (!project || project.tenantId !== tenantId) {
      throw new NotFoundException(`Project ${id} not found`);
    }
    return project;
  }

  // ✅ create — inject tenantId from context
  async create(dto: CreateProjectDto, tenantId: string): Promise<Project> {
    return this.prisma.project.create({
      data: { ...dto, tenantId },
    });
  }

  // ✅ update — verify ownership before updating
  async update(id: string, dto: UpdateProjectDto, tenantId: string): Promise<Project> {
    await this.findOne(id, tenantId); // throws if not found or wrong tenant
    return this.prisma.project.update({
      where: { id },
      data: dto,
    });
  }

  // ✅ delete — verify ownership before deleting
  async remove(id: string, tenantId: string): Promise<void> {
    await this.findOne(id, tenantId);
    await this.prisma.project.delete({ where: { id } });
  }
}
```

---

## 3. NestJS Controller Pattern

```typescript
@ApiTags('projects')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, TenantGuard)  // ← ALWAYS both guards
@Controller('projects')
export class ProjectController {
  constructor(private readonly projectService: ProjectService) {}

  @Get()
  @ApiOperation({ summary: 'List all projects for current tenant' })
  findAll(@CurrentTenant() tenantId: string) {
    return this.projectService.findAll(tenantId);
  }

  @Post()
  create(@Body() dto: CreateProjectDto, @CurrentTenant() tenantId: string) {
    return this.projectService.create(dto, tenantId);
  }
}
```

---

## 4. TenantGuard Pattern

```typescript
@Injectable()
export class TenantGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const tenantId = request.user?.tenantId;

    if (!tenantId) {
      throw new UnauthorizedException('Tenant context required');
    }

    return true;
  }
}
```

---

## 5. JWT Payload Pattern

```typescript
interface JwtPayload {
  sub: string;       // userId
  tenantId: string;  // ← REQUIRED in every token
  email: string;
  role: UserRole;
}
```

---

## 6. Anti-Patterns to AVOID

```typescript
// ❌ Missing tenantId
prisma.project.findMany()

// ❌ Using raw SQL without tenantId
prisma.$queryRaw`SELECT * FROM projects WHERE id = ${id}`

// ❌ Assuming ownership without verification
prisma.project.findUnique({ where: { id } })
// → Could return another tenant's data!

// ❌ Update without ownership check
prisma.project.update({ where: { id }, data: dto })
// → Could update another tenant's record!
```
