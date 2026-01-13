import { UpdateSessionSetDto } from "../dto/session-set.dto";
import SessionSet, { SessionSetCreationAttributes } from "../models/sessionSet";
import { SessionSetRepository } from "../repository/session-set.repository";

export class SessionSetService {
    private repo = new SessionSetRepository();

    async list(): Promise<SessionSet[]> {
        return this.repo.list();
    }

    async getOne(id: string): Promise<SessionSet | null> {
        return this.repo.getOne(id);
    }

    async create(data: SessionSetCreationAttributes): Promise<SessionSet | null> {
        return this.repo.create(data);
    }

    async update(data: UpdateSessionSetDto): Promise<SessionSet | null> {
        return this.repo.update(data);
    }

    async delete(id: string): Promise<void> {
        return this.repo.delete(id);
    }
}