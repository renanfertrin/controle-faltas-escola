-- Atualização do Controle de Faltas
-- 1) adiciona FOM - Formação às siglas aceitas
-- 2) padroniza nomes dos professores
-- 3) garante que futuros cadastros/edições também sejam padronizados no banco

begin;

create or replace function public.normalize_person_name(p_name text)
returns text
language plpgsql
immutable
set search_path = public
as $$
declare
  part text;
  result text := '';
  normalized text;
begin
  if p_name is null then
    return null;
  end if;

  p_name := regexp_replace(btrim(p_name), '\s+', ' ', 'g');
  if p_name = '' then
    return '';
  end if;

  foreach part in array regexp_split_to_array(lower(p_name), '\s+') loop
    if result <> '' and part = any(array['de','da','do','das','dos','e']) then
      normalized := part;
    else
      normalized := initcap(part);
    end if;

    result := result || case when result = '' then '' else ' ' end || normalized;
  end loop;

  return result;
end;
$$;

create or replace function public.normalize_teacher_name_trigger()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.name := public.normalize_person_name(new.name);
  return new;
end;
$$;

drop trigger if exists trg_normalize_teacher_name on public.teachers;

create trigger trg_normalize_teacher_name
before insert or update of name on public.teachers
for each row
execute function public.normalize_teacher_name_trigger();

-- Corrige os nomes já existentes sem alterar os IDs nem o histórico.
update public.teachers
set name = public.normalize_person_name(name)
where name is distinct from public.normalize_person_name(name);

-- Atualiza a lista de siglas permitidas no banco.
alter table public.absences
  drop constraint if exists absences_reason_code_check;

alter table public.absences
  add constraint absences_reason_code_check
  check (
    reason_code is null
    or reason_code = any(array[
      'A','LAT','AM','AM/2','AT','FA','F','G','I','I/2','J','J/2',
      'LA','LC','LF','LF-1','LF-4','LG','LP','LPA','LS','LSV','N','NC',
      'RE','SO','T.R.E.','FREQ','ANL','DS','FOM'
    ]::text[])
  );

commit;
