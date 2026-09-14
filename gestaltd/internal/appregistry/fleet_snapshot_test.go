package appregistry

import (
	"context"
	"errors"
	"fmt"
	"testing"
	"time"

	"github.com/valon-technologies/gestalt/server/core"
)

type snapshotSource struct {
	calls int
	state *core.GestaltdSourceVersionState
	err   error
}

func (s *snapshotSource) Get(context.Context) (*core.GestaltdSourceVersionState, error) {
	s.calls++
	return s.state, s.err
}

type snapshotHeartbeats struct {
	calls int
	rows  []*core.GestaltdInstanceHeartbeat
	err   error
}

func (h *snapshotHeartbeats) ListFreshBySourceVersion(context.Context, string, time.Time) ([]*core.GestaltdInstanceHeartbeat, error) {
	h.calls++
	return h.rows, h.err
}

func TestFleetSnapshotSharesReadsAndEvaluationTime(t *testing.T) {
	now := time.Date(2026, 9, 14, 21, 0, 0, 0, time.UTC)
	source := &snapshotSource{state: &core.GestaltdSourceVersionState{CurrentSourceVersion: "source", MinimumHealthyInstances: 1}}
	apps := map[string]core.GestaltdInstanceAppHeartbeat{}
	for i := range 29 {
		apps[fmt.Sprint(i)] = core.GestaltdInstanceAppHeartbeat{State: core.GestaltdInstanceAppStateRunning, RunningVersion: "v1"}
	}
	heartbeats := &snapshotHeartbeats{rows: []*core.GestaltdInstanceHeartbeat{heartbeatForFleet("one", "source", now, apps)}}
	p := &FleetProjector{SourceVersions: source, Heartbeats: heartbeats, HeartbeatTTL: time.Minute, Now: func() time.Time { return now }}
	snapshot, err := p.Snapshot(context.Background())
	if err != nil {
		t.Fatal(err)
	}
	// A later source update must not change the basis halfway through a list.
	source.state.CurrentSourceVersion = "next"
	source.state.MinimumHealthyInstances = 10
	for i := range 29 {
		got := snapshot.Project(fmt.Sprint(i), "v1", nil)
		if got.State != core.AppFleetStateHealthy || got.SourceVersion != "source" || !got.EvaluatedAt.Equal(now) || got.HeartbeatTTL != time.Minute {
			t.Fatalf("projection = %#v", got)
		}
	}
	if source.calls != 1 || heartbeats.calls != 1 {
		t.Fatalf("reads: source=%d heartbeats=%d", source.calls, heartbeats.calls)
	}
}

func TestFleetSnapshotMissingSourceAndErrors(t *testing.T) {
	for _, sourceErr := range []error{core.ErrNotFound, errors.New("storage unavailable")} {
		source := &snapshotSource{err: sourceErr}
		heartbeats := &snapshotHeartbeats{}
		p := &FleetProjector{SourceVersions: source, Heartbeats: heartbeats, HeartbeatTTL: time.Minute}
		snapshot, err := p.Snapshot(context.Background())
		if errors.Is(sourceErr, core.ErrNotFound) {
			if err != nil {
				t.Fatal(err)
			}
			got := snapshot.Project("app", "v1", nil)
			if got.State != core.AppFleetStateUnknown || got.DesiredVersion != "v1" {
				t.Fatalf("projection = %#v", got)
			}
		} else if !errors.Is(err, sourceErr) {
			t.Fatalf("got %v, want %v", err, sourceErr)
		}
		if heartbeats.calls != 0 {
			t.Fatal("read heartbeats without a source")
		}
	}
	p := &FleetProjector{SourceVersions: &snapshotSource{state: &core.GestaltdSourceVersionState{CurrentSourceVersion: "source"}}, Heartbeats: &snapshotHeartbeats{err: context.Canceled}, HeartbeatTTL: time.Minute}
	if _, err := p.Snapshot(context.Background()); !errors.Is(err, context.Canceled) {
		t.Fatalf("got %v", err)
	}
}
